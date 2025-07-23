# FileComp

FileComp recursively compares two directories for unique files using their hash values.  
To accomplish this, the program runs through a series of steps.

**Steps:**  
(1) Select base directory.  
(2) Select directory to compare.  
(3) Choose hash algorithm (e.g., SHA1).  
(4) Choose number of threads to run on.
(5) Choose output: log, copy, or both.  
(6) (Optional) Select folder to copy unique files.  
(7) Decide whether to keep or delete hash DB.

Use **arrow keys** and **Enter** to navigate menus.  
Press **Q** anytime to quit.

FileComp operates carefully with your files and will neither change nor move them.

**Hashing:**  
It calculates hashes for files to detect unique ones, rather than looking for names.  
Therefore you can choose from different hashing algorithms (e.g. SHA1, MD5, B2).

**Comparison:**  
Choose source and target directories for comparison through arrow key navigation.  
Files from target will be compared with those from base and treated as unique.

**Database:**  
The program will create a database of file hashes to speed up the process.  
This database will remain in your working directory unless you delete it.

**Copying:**  
Beside of logging unique files, FileComp can copies them to a chosen directory.  
The original files are kept safe.

Users are guided safely through the individual steps, no text input is necessary.
  
**Navigation:**  
The controls work intuitively and do not require any direct text input.  
Available commands are listed below, at the bottom of the screen.
  
**Select Directories:**  
Directories are selected using lists that can be navigated through the arrow keys.  
The program can search the entire tree, starting from the home folder.
  
**Hash Algorithm:**  
FileComp works with various hash algorithms that are installed on your machine.
  
**Output Mode:**  
By default, the list of unique files will be recorded within a log.  
The second method is to copy the files to a new folder.