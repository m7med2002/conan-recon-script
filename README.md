# 🕵️ Detective Conan - Recon Script

> **An automated reconnaissance script powered by the sharp instincts of Detective Conan!**

Detective Conan is a powerful Bash script that automates the reconnaissance phase of bug bounty hunting and cybersecurity investigations. It uses a collection of elite open-source tools to gather subdomains, check for live hosts, discover parameters, extract hidden URLs, and more.

---

## ⚙️ What It Does

- 📜 Cleans your scope file and removes wildcards
- 🌐 Enumerates subdomains with `subfinder` and `haktrails`
- 🔎 Checks which subdomains are live using `httpx`
- 📂 Collects historical URLs using `waybackurls`
- 🧪 Finds parameters using `paramspider` and `arjun`
- ☢️ Identifies potential XSS points with `kxss`
- 📁 Extracts JS/Java files and other media types

---

## 🔧 Required Tools

Make sure the following tools are installed and accessible in your `$PATH`:

- [`subfinder`](https://github.com/projectdiscovery/subfinder)
- [`haktrails`](https://github.com/hakluke/haktrails)
- [`httpx`](https://github.com/projectdiscovery/httpx)
- [`waybackurls`](https://github.com/tomnomnom/waybackurls)
- [`paramspider`](https://github.com/devanshbatham/paramspider)
- [`arjun`](https://github.com/s0md3v/Arjun)
- [`kxss`](https://github.com/Emoe/kxss)
- [`anew`](https://github.com/tomnomnom/anew)

---

## 🚀 Usage

1. Create a file named `scop.txt` and place one domain per line (can contain wildcards like `*.target.com`).
2. Give the script executable permissions:

```bash
chmod +x conan.sh
