# 🎓 Student Record System (32-Bit x86 Assembly)

A lightweight, low-level **Student Record System** implemented in **32-Bit x86 Linux Assembly (NASM)** using system interrupts (`int 0x80`). This project demonstrates manual memory management, array manipulation, input/output buffering, and standard system calls in Assembly language.

---

## ✨ Features

- **➕ Add Student Record:** Captures Student ID, Name, and GPA, storing them dynamically into a structured memory array.
- **📋 View All Records:** Displays all saved student records in a structured tabular format.
- **🚪 System Exit:** Terminates the process cleanly using Linux System Calls (`sys_exit`).
- **⚡ High Performance:** Built directly close to hardware with zero high-level language dependencies.

---

## 🛠️ Built With

* **Language:** x86 Assembly (32-bit)
* **Assembler:** NASM (Netwide Assembler)
* **Kernel Call System:** Linux `int 0x80` Syscalls (`sys_write`, `sys_read`, `sys_exit`)

---

## 📸 Demo Output

```text
=== STUDENT RECORD SYSTEM (32-BIT ASSEMBLY) ===[cite: 1]
1. Add Student Record[cite: 1]
2. View All Student Records[cite: 1]
3. Exit System[cite: 1]
Enter Choice (1-3): 1[cite: 1]

Enter Student ID (e.g. 101): 50[cite: 1]
Enter Student Name: maju[cite: 1]
Enter GPA (e.g. 3.8): 3[cite: 1]

[+] Student record added successfully to memory![cite: 1]