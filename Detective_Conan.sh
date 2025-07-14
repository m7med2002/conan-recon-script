#!/bin/bash

# Banner
echo -e "\033[1;31m" # Red bold
cat << "EOF"
    ____               _           _    ____                _        
   |  _ \ ___  __ _ _ _| |_ ___ _ _| |_ |  _ \ ___  __ _ _ __(_) __ _ 
   | | | / _ \/ _` | '_|  _/ _ \ '_|  _|| | | |/ _ \/ _` | '__| |/ _` |
   | |_| |  __/ (_| | |  | ||  __/ |  | |_ | |_| |  __/ (_| | |  | | (_| |
   |____/ \___|\__,_|_|   \__\___|_|   \__||____/ \___|\__,_|_| |_|\__,_|
                       - The Ultimate Recon Script -
EOF
echo -e "\033[0m" # Reset color

# Set the output directory to organize all your findings
output_dir="recon_$(date +%Y%m%d)"
mkdir -p "$output_dir"
cd "$output_dir" || { echo "[-] Failed to access output directory"; exit 1; }

echo "[+] Starting the reconnaissance process..."

# Process the scope file to clean up wildcard entries
echo "[+] Processing the scope file..."
if [ -f "../scop.txt" ]; then
    cat ../scop.txt | sed 's/\*\.//g' > scop2.txt
else
    echo "[-] scop.txt not found. Please provide the file."
    exit 1
fi

# Use subfinder for a deep dive into subdomain enumeration
echo "[+] Enumerating subdomains using subfinder..."
while IFS= read -r domain; do
    echo "[+] Scanning domain: $domain"
    subfinder -d "$domain" -all --recursive >> subs.txt
done < scop2.txt

# Add extra subdomains with haktrails for comprehensive coverage
echo "[+] Fetching additional subdomains using haktrails..."
cat scop2.txt | haktrails subdomains >> subs.txt

# Deduplicate the subdomains for cleaner output
echo "[+] Removing duplicate subdomains..."
cat subs.txt | anew > allsubs.txt

# Verify which subdomains are live and reachable
echo "[+] Verifying active subdomains..."
cat allsubs.txt | httpx -mc 200 -o httpx200.txt

# Collect historical data to uncover hidden URLs
echo "[+] Collecting historical URLs..."
cat httpx200.txt | waybackurls > urls.txt

# Use paramspider to dig into potential parameters
echo "[+] Searching for parameters with paramspider..."
paramspider -l httpx200.txt && {
    echo "[+] paramspider completed. Processing results..."
    if [ -d "results" ]; then
        cd results || exit
        if [ "$(ls -A)" ]; then
            cat * | anew >> ../paramspider.txt
            echo "[+] Paramspider results saved to paramspider.txt"
        else
            echo "[!] 'results' directory is empty"
        fi
        cd ..
        rm -rf results
        echo "[+] 'results' directory removed"
    else
        echo "[!] 'results' directory not found"
    fi
}

# Discover hidden parameters with arjun for fuzzing opportunities
echo "[+] Discovering hidden parameters with arjun..."
arjun -i httpx200.txt -w /home/jimmy/bug_bounty/wordlists/parameter_fuzz.txt -oT arjun.txt

# Run kxss to identify potential XSS vulnerabilities
echo "[+] Extracting potential XSS vulnerabilities using kxss..."
cat * | kxss >> xss_unfilterd.txt

# Extract URLs containing parameters for manual testing
echo "[+] Extracting URLs with parameters..."
cat * | grep -E '=\w+' | grep -vE '\.(json|css|js|woff2|png|jpg|jpeg|svg|gif)$' | sort | anew >> parametersurls.txt

# Hunt down JavaScript and Java files for potential vulnerabilities
echo "[+] Extracting JavaScript and Java files..."
cat * | grep -Ei '\.(java|js)$' | sort | anew >> js_files.txt

# Collect media files and other relevant file types
echo "[+] Extracting media files and other file types..."
cat * | grep -Ei '\.(png|jpg|jpeg|svg|gif|bmp|ico|pdf|doc|docx|xls|xlsx|ppt|pptx)$' | sort | anew >> media_files.txt

# Final message indicating success
echo -e "\033[1;32m" # Green bold
echo "[+] Reconnaissance process completed. Results saved in $output_dir."
echo -e "\033[1;36m" # Cyan bold
echo "I will dive into this more than I can, until all my curiosity dries out!"
echo -e "\033[0m" # Reset color
