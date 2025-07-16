# 🔐 Free SSL Setup with Certbot and Kubernetes (Istio)

This guide walks you through creating a **free wildcard SSL certificate** using Certbot, converting it to `.pfx` if needed, and deploying it as a TLS secret in **Kubernetes** (Istio Ingress Gateway compatible).

---

## 📦 Step 1: Install Certbot

### ✅ On **Linux** (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install certbot
```

### ✅ On **macOS** (with Homebrew)

```bash
brew install certbot
```

### ✅ On **Windows**

Use the [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install) to install a Linux shell, then install Certbot inside it using the Linux instructions.

---

## 🛠️ Step 2: Create a Wildcard Certificate Using Certbot

Use the following command to generate a wildcard certificate via DNS challenge:

```bash
sudo certbot certonly \
  --manual \
  --preferred-challenges dns \
  --key-type rsa \
  -d "*.mydns.com"
```

> 📌 Certbot will prompt you to add a TXT DNS record in your domain's DNS settings. After validation, it will generate the cert files.

---

## 📁 Output Files (Usually in `/etc/letsencrypt/live/mydns.com/`)

* `cert.pem` – SSL certificate
* `privkey.pem` – Private key
* `chain.pem` – Intermediate certificate
* `fullchain.pem` – `cert.pem + chain.pem` combined ✅

---

## 🔄 Step 3 (Optional): Convert to `.pfx` Format

If you need `.pfx` format for Azure, Windows, or other platforms:

```bash
openssl pkcs12 -export \
  -out mycert.pfx \
  -inkey privkey.pem \
  -in cert.pem \
  -certfile chain.pem \
  -password pass:mypass
```

> Replace `mypass` with your desired export password.

---

## 🔍 Check if Certificate and Private Key Match

### 🔄 Convert Private Key to RSA Format (if needed)
If your private key is not already in RSA format, convert it with:

```bash
openssl rsa -in privkey.pem -out rsa-key.pem
```

### 🔹 Step 1: Check the modulus of the private key

```bash
openssl rsa -noout -modulus -in privkey.pem | openssl md5
```
Or use the RSA-converted key if you previously converted:
```bash
openssl rsa -noout -modulus -in rsa-key.pem | openssl md5
```

### 🔹 Step 2: Check the modulus of the certificate

```bash
openssl x509 -noout -modulus -in cert.pem | openssl md5
```

### 🔹 Step 3: Compare the output

- ✅ If both MD5 hashes are identical → the certificate and key match
- ❌ If the hashes are different → the certificate and key do NOT match

### 🧪 Example Output

```bash
openssl rsa -noout -modulus -in privkey.pem | openssl md5
=> d41d8cd98f00b204e9800998ecf8427e

openssl x509 -noout -modulus -in cert.pem | openssl md5
=> d41d8cd98f00b204e9800998ecf8427e
```

✅ These match → you're good to build the .pfx.

---

## ☸️ Step 4: Create Kubernetes TLS Secret (Istio Compatible)

### ❌ If using `cert.pem` (⚠️ Not Recommended)

```bash
kubectl create -n istio-system secret tls mydomain-tls \
  --cert=cert.pem \
  --key=privkey.pem
```

### ✅ Recommended: Use `fullchain.pem`

```bash
kubectl create -n istio-system secret tls mydomain-tls \
  --cert=fullchain.pem \
  --key=privkey.pem
```

> `fullchain.pem` ensures the **entire certificate chain** is trusted by clients like browsers, gateways, and ingress controllers.

---

## ✅ Final Verification

Check that the secret is created:

```bash
kubectl get secret mydomain-tls -n istio-system
```

Verify that your **Istio Gateway** references the correct secret:

```yaml
tls:
  mode: SIMPLE
  credentialName: mydomain-tls
```

---

## 🧠 Tips

* Automate renewal and secret updates with `cert-manager` if needed.
* Avoid using `cert.pem` alone—use `fullchain.pem` to prevent trust issues.
* Use `kubectl describe secret` to troubleshoot issues.

---

