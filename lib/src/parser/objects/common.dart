import '../shared/parser_generator.dart';

class CommonDXFObject {
  final String ownerObjectId;
  final String ownerDictionaryIdHard;
  final String ownerDictionaryIdSoft;
  final String handle;

  CommonDXFObject({
    required this.ownerObjectId,
    required this.ownerDictionaryIdHard,
    required this.ownerDictionaryIdSoft,
    required this.handle,
  });
}

final commonObjectSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [330],
    name: 'ownerObjectId',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [102],
    // end of ACAD_XDICTIONARY
  ),
  DXFParserSnippet(
    code: [360],
    name: 'ownerDictionaryIdHard',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [102],
    // start of ACAD_XDICTIONARY
  ),
  DXFParserSnippet(
    code: [102],
    // end of ACAD_REACTOR
  ),
  DXFParserSnippet(
    code: [330],
    name: 'ownerDictionaryIdSoft',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [102],
    // start of ACAD_REACTOR
  ),
  DXFParserSnippet(
    code: [102],
    // end of application defined
  ),
  DXFParserSnippet(
    code: [102],
    // start of application defined
  ),
  DXFParserSnippet(
    code: [5],
    name: 'handle',
    parser: identity,
  ),
];
