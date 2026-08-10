import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'hierarchy_service.dart';
import 'id_generator.dart';

class ContentBlockService {
  const ContentBlockService(this._blocks, this._ideas, this._ids, this._clock);

  final ContentBlockRepository _blocks;
  final IdeaRepository _ideas;
  final IdGenerator _ids;
  final Clock _clock;

  Future<List<ContentBlock>> load(EntityId ideaId) {
    return _blocks.listActiveByIdea(ideaId);
  }

  Future<ContentBlock> create(
    EntityId ideaId,
    ContentBlockType type, {
    required int sortOrder,
    String text = '',
    Map<String, Object?>? metadata,
  }) async {
    final idea = await _ideas.getById(ideaId);
    if (idea == null || idea.isDeleted) {
      throw StateError('The Idea is unavailable.');
    }
    final now = _clock().toUtc();
    return _blocks.create(
      ContentBlock(
        id: _ids.next(),
        ideaId: ideaId,
        type: type,
        sortOrder: sortOrder,
        text: type == ContentBlockType.divider ? '' : text,
        metadata: metadata ?? defaultMetadata(type),
        payloadVersion: 1,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      ),
    );
  }

  Future<ContentBlock> update(
    ContentBlock block, {
    ContentBlockType? type,
    String? text,
    Map<String, Object?>? metadata,
  }) {
    final nextType = type ?? block.type;
    return _blocks.update(
      id: block.id,
      type: nextType,
      text: nextType == ContentBlockType.divider ? '' : text ?? block.text,
      metadata: metadata ?? block.metadata,
      updatedAt: _clock().toUtc(),
    );
  }

  Future<void> reorder(EntityId ideaId, List<EntityId> orderedIds) {
    return _blocks.reorder(
      ideaId: ideaId,
      orderedIds: orderedIds,
      updatedAt: _clock().toUtc(),
    );
  }

  Future<void> softDelete(EntityId id) {
    return _blocks.softDelete(id, _clock().toUtc());
  }

  Future<void> setDeleted(EntityId id, bool isDeleted) {
    return _blocks.setDeleted(
      id,
      isDeleted: isDeleted,
      updatedAt: _clock().toUtc(),
    );
  }

  static Map<String, Object?> defaultMetadata(ContentBlockType type) {
    return switch (type) {
      ContentBlockType.heading => const {'level': 1},
      ContentBlockType.code => const {'language': 'plainText'},
      ContentBlockType.checklist => const {'checked': false},
      _ => const {},
    };
  }
}

class BlockInputCommand {
  const BlockInputCommand(this.type, [this.metadata = const {}]);

  final ContentBlockType type;
  final Map<String, Object?> metadata;
}

class BlockCommandOption {
  const BlockCommandOption({
    required this.label,
    required this.command,
    required this.result,
    this.searchTerms = const [],
  });

  final String label;
  final String command;
  final BlockInputCommand result;
  final List<String> searchTerms;
}

final blockCommandOptions = <BlockCommandOption>[
  for (final entry in const <String, ContentBlockType>{
    '/paragraph': ContentBlockType.paragraph,
    '/heading': ContentBlockType.heading,
    '/code': ContentBlockType.code,
    '/checklist': ContentBlockType.checklist,
    '/bullets': ContentBlockType.bulletList,
    '/numbered': ContentBlockType.numberedList,
    '/quote': ContentBlockType.quote,
    '/divider': ContentBlockType.divider,
  }.entries)
    BlockCommandOption(
      label: switch (entry.value) {
        ContentBlockType.paragraph => 'Paragraph',
        ContentBlockType.heading => 'Heading',
        ContentBlockType.code => 'Code',
        ContentBlockType.checklist => 'Checklist',
        ContentBlockType.bulletList => 'Bulleted List',
        ContentBlockType.numberedList => 'Numbered List',
        ContentBlockType.quote => 'Quote',
        ContentBlockType.divider => 'Divider',
      },
      command: entry.key,
      result: BlockInputCommand(
        entry.value,
        ContentBlockService.defaultMetadata(entry.value),
      ),
    ),
  ...const <(String, String, String)>[
    ('C#', '/csharp', 'csharp'),
    ('Python', '/python', 'python'),
    ('JavaScript', '/javascript', 'javascript'),
    ('TypeScript', '/typescript', 'typescript'),
    ('SQL', '/sql', 'sql'),
    ('JSON', '/json', 'json'),
    ('HTML', '/html', 'html'),
    ('CSS', '/css', 'css'),
    ('Dart', '/dart', 'dart'),
  ].map(
    (entry) => BlockCommandOption(
      label: 'Code â€” ${entry.$1}',
      command: entry.$2,
      result: BlockInputCommand(ContentBlockType.code, {'language': entry.$3}),
      searchTerms: switch (entry.$3) {
        'csharp' => const ['cs', 'c#'],
        'javascript' => const ['js'],
        'typescript' => const ['ts'],
        _ => const [],
      },
    ),
  ),
];

List<BlockCommandOption> filterBlockCommands(String input) {
  final query = input.trim().toLowerCase().replaceFirst('/', '');
  return blockCommandOptions.where((option) {
    final values = [
      option.label.toLowerCase(),
      option.command.substring(1),
      ...option.searchTerms,
    ];
    return query.isEmpty || values.any((value) => value.startsWith(query));
  }).toList();
}

BlockInputCommand? parseBlockInputCommand(String input) {
  final value = input.trim().toLowerCase();
  const blocks = <String, ContentBlockType>{
    '/paragraph': ContentBlockType.paragraph,
    '/heading': ContentBlockType.heading,
    '/code': ContentBlockType.code,
    '/checklist': ContentBlockType.checklist,
    '/bullets': ContentBlockType.bulletList,
    '/numbered': ContentBlockType.numberedList,
    '/quote': ContentBlockType.quote,
    '/divider': ContentBlockType.divider,
  };
  final type = blocks[value];
  if (type != null) {
    return BlockInputCommand(type, ContentBlockService.defaultMetadata(type));
  }

  const languages = <String, String>{
    '/csharp': 'csharp',
    '/python': 'python',
    '/js': 'javascript',
    '/javascript': 'javascript',
    '/typescript': 'typescript',
    '/sql': 'sql',
    '/json': 'json',
    '/html': 'html',
    '/css': 'css',
    '/dart': 'dart',
  };
  final slashLanguage = languages[value];
  if (slashLanguage != null) {
    return BlockInputCommand(ContentBlockType.code, {
      'language': slashLanguage,
    });
  }

  if (value.startsWith('```')) {
    final marker = value.substring(3).trim();
    const fences = <String, String>{
      '': 'plainText',
      'csharp': 'csharp',
      'cs': 'csharp',
      'python': 'python',
      'py': 'python',
      'js': 'javascript',
      'javascript': 'javascript',
      'typescript': 'typescript',
      'ts': 'typescript',
      'sql': 'sql',
      'json': 'json',
      'html': 'html',
      'css': 'css',
      'dart': 'dart',
      'bash': 'bash',
      'powershell': 'powershell',
    };
    final language = fences[marker];
    if (language != null) {
      return BlockInputCommand(ContentBlockType.code, {'language': language});
    }
  }
  return null;
}
