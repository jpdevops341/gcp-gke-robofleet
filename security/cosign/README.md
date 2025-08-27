# Cosign (optional)
- Generate key pair: `cosign generate-key-pair`
- Sign: `cosign sign --key cosign.key $IMAGE_REF`
- Verify: `cosign verify --key cosign.pub $IMAGE_REF`