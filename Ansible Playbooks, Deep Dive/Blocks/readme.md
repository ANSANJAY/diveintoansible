
### ✅ **Revision 01: Basic Block Usage**

#### 📜 Playbook Snippet

```yaml
tasks:
  - name: A Basic Block
    block:
      - name: Task 1
        debug:
          msg: "Inside Block - Task 1"

      - name: Task 2
        debug:
          msg: "Inside Block - Task 2"
```

#### 🧠 Explanation

| **Code**                       | **Explanation**                |
| ------------------------------ | ------------------------------ |
| `block:`                       | Groups tasks logically.        |
| `debug:`                       | Simple debug message for demo. |
| `msg: "Inside Block - Task X"` | Output confirms the task ran.  |

---

### ✅ **Revision 02: Using Loops & Conditions with Blocks**

#### 📜 Playbook Snippet

```yaml
tasks:
  - name: Block with Loop and Condition
    block:
      - name: Show OS info
        debug:
          msg: "{{ item }}"
        with_items:
          - "This is CentOS"
          - "This is Ubuntu"
    when: ansible_os_family is defined
```

#### 🧠 Explanation

| **Code**                     | **Explanation**                       |
| ---------------------------- | ------------------------------------- |
| `with_items`                 | Loops over items in block.            |
| `when: ansible_os_family...` | Block executes only if condition met. |
| `debug: msg: "{{ item }}"`   | Shows item from loop.                 |

---

### ✅ **Revision 03: Adding Rescue for Error Handling**

#### 📜 Playbook Snippet

```yaml
tasks:
  - name: Install Packages with Rescue
    block:
      - name: Install patch
        package:
          name: patch
          state: present

      - name: Install python-dns
        package:
          name: python-dns
          state: present
    rescue:
      - name: Rollback patch
        package:
          name: patch
          state: absent

      - name: Rollback python-dns
        package:
          name: python-dns
          state: absent
```

#### 🧠 Explanation

| **Code**   | **Explanation**                      |
| ---------- | ------------------------------------ |
| `block:`   | Try to install both packages.        |
| `rescue:`  | If any package fails, rollback both. |
| `package:` | Ensures installation/uninstallation. |

---

### ✅ **Revision 04: Adding Always Block**

#### 📜 Playbook Snippet

```yaml
tasks:
  - name: Install with Full Error Handling
    block:
      - name: Install patch
        package:
          name: patch
          state: present

      - name: Install python-dns
        package:
          name: python-dns
          state: present
    rescue:
      - name: Cleanup
        package:
          name: patch
          state: absent
    always:
      - name: Final Notification
        debug:
          msg: "Task completed"
```

#### 🧠 Explanation

| **Code**  | **Explanation**                                  |
| --------- | ------------------------------------------------ |
| `always:` | Executes **no matter what** (even on success).   |
| `debug:`  | Used here for final log/notification.            |
| Full flow | `block -> rescue -> always` covers all outcomes. |

---

