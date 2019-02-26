const ethSigUtil = require("eth-sig-util");

// private key for address 0x53dc60587F48Fdf89627A895DCecF12d65B9B650
const contract_address = '0xc6151d4fdfc5ee38e7c2dd46ddb5825383aa3389';
console.log('contract address', contract_address);
console.log('expected address', '0x41eed7527da17230ce86fa86a777c28508ee32f5');

// signer private key:
const signer_private_key_hex = '8e9e9b7692c0115312ff09f99324a936950401209f68a08e058926a8c32af712';
const signer_private_key = Buffer.from(signer_private_key_hex, 'hex');

const dstAddress = '0xBb2A707C98366bf1668cA5D7E0Eb60Bc14A5632b';
console.log('dstAddress', dstAddress);

const domain = [
  { name: "name", type: "string" },
  { name: "version", type: "string" },
  { name: "chainId", type: "uint256" },
  { name: "verifyingContract", type: "address" },
  { name: "salt", type: "bytes32" },
];
const withdraw = [
  { name: "dst", type: "address" },
];

const domainData = {
  name: "Withdraw dApp",
  version: "2",
  chainId: parseInt(5777),
  verifyingContract: contract_address,
  salt: "0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558"
};

var message = {
  dst: dstAddress
};

const data = {
  types: {
    EIP712Domain: domain,
    Withdraw: withdraw,
  },
  domain: domainData,
  primaryType: "Withdraw",
  message: message
};

console.log('Data');
console.log(data);

const bufferToSign = ethSigUtil.TypedDataUtils.sign(data);
console.log(ethSigUtil.TypedDataUtils.sanitizeData(data));
const hexToSign = bufferToSign.toString('hex');

const expectedHash = '0xab5132d91a62f77b20fa99380e753ee6485f5f0ad1e90f6b018defebe5a8c881';
console.log('hex to sign');
console.log('0x' + hexToSign);
console.log('expected');
console.log(expectedHash);
console.log('match', expectedHash == '0x' + hexToSign)
const addressSignature = ethSigUtil.signTypedData(signer_private_key, {data: data});
console.log("Signature");
console.log(addressSignature);

const r = '0x' + addressSignature.substr(2, 64);
const s = '0x' + addressSignature.substr(66, 64);
const v = '0x' + addressSignature.substr(-2, 2);

console.log('r', r);
console.log('s', s);
console.log('v', v);