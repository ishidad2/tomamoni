class Block {
  final String signature;
  final String signerPublicKey;
  final int version;
  final int network;
  final int type;
  final int height;
  final int timestamp;
  final int difficulty;
  final String proofGamma;
  final String proofVerificationHash;
  final String proofScalar;
  final String previousBlockHash;
  final String transactionsHash;
  final String receiptsHash;
  final String stateHash;
  final String beneficiaryAddress;
  final int feeMultiplier;

  Block({
    required this.signature,
    required this.signerPublicKey,
    required this.version,
    required this.network,
    required this.type,
    required this.height,
    required this.timestamp,
    required this.difficulty,
    required this.proofGamma,
    required this.proofVerificationHash,
    required this.proofScalar,
    required this.previousBlockHash,
    required this.transactionsHash,
    required this.receiptsHash,
    required this.stateHash,
    required this.beneficiaryAddress,
    required this.feeMultiplier,
  });

  // JSONデータからBlockオブジェクトを作成するファクトリコンストラクタ
  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      signature: json['signature'] as String,
      signerPublicKey: json['signerPublicKey'] as String,
      version: json['version'] as int,
      network: json['network'] as int,
      type: json['type'] as int,
      height: int.parse(json['height'] as String),
      timestamp: int.parse(json['timestamp'] as String),
      difficulty: int.parse(json['difficulty'] as String),
      proofGamma: json['proofGamma'] as String,
      proofVerificationHash: json['proofVerificationHash'] as String,
      proofScalar: json['proofScalar'] as String,
      previousBlockHash: json['previousBlockHash'] as String,
      transactionsHash: json['transactionsHash'] as String,
      receiptsHash: json['receiptsHash'] as String,
      stateHash: json['stateHash'] as String,
      beneficiaryAddress: json['beneficiaryAddress'] as String,
      feeMultiplier: json['feeMultiplier'] as int,
    );
  }
}
