
## 🔁 Ansible Looping: Side-by-Side Examples + Explanation

| **Playbook File**           | **Loop Type**                         | **What it Does**                                            | **Simplified Explanation**                                                                                         |
| --------------------------- | ------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `03_loop_with_items.yml`    | `with_items`                          | Runs the same task (e.g., print MOTD) for each OS in list.  | Loop over list of OSes: `['CentOS', 'Ubuntu']`. Applies message only if `ansible_distribution` matches.            |
| `05_user_creation_loop.yml` | `with_items`                          | Creates users using a list.                                 | A simple list like `['james', 'hayley']` creates a user account per item.                                          |
| `07_user_dict_loop.yml`     | `with_dict`                           | Uses dictionary for user → full name.                       | Loops over `key: value` where key is username and value is full name (used for comment).                           |
| `09_subelements.yml`        | `with_subelements`                    | Loops over nested lists (e.g., families with members).      | Useful for structured data: parent item has nested array. Example: loop over families and their members.           |
| `10_subelements_expand.yml` | `with_subelements` with expanded data | Scales to multiple family dictionaries.                     | Allows more flexibility: each dict = one family + members. Clean, scalable structure.                              |
| `11_password_hash.yml`      | `with_subelements` + password setup   | Adds random secure password for each user.                  | Uses `lookup('password')` to generate a secure password and `password_hash('sha512')` to store it.                 |
| `12_user_dirs_nested.yml`   | `with_nested`                         | Creates multiple folders (docs/photos) for each user.       | Every user gets every folder. Example of 3 folders × 4 users = 12 directory creations.                             |
| `13_with_together.yml`      | `with_together`                       | Loops through two lists in parallel.                        | Pairing user with interest: `['freya', 'ana']` with `['acting', 'japanese']`. Not every combo – just matched ones. |
| `14_ssh_keys_with_file.yml` | `with_file`                           | Reads content of file (e.g., `.pub` key) and loops over it. | Adds public key content to authorized\_keys using `authorized_key` module.                                         |
| `15_multiple_ssh_keys.yml`  | `with_file` with list                 | Adds multiple SSH keys using loop.                          | Same as above, but reads multiple key files and adds all of them.                                                  |
| `16_with_sequence.yml`      | `with_sequence`                       | Creates directories using numeric ranges.                   | Generates loop from 0 to 100 (step 10), used to create numbered directories.                                       |
| `18_sequence_hex.yml`       | `with_sequence` with formatting       | Uses hex instead of decimal                                 | `%x` = hex format. Directories like `0`, `a`, `b`, ..., `f`, `10`, etc.                                            |
| `19_random_choice.yml`      | `with_random_choice`                  | Creates directory from a random choice list.                | Pick one randomly from `['google', 'facebook', 'apple']` and make a dir with that name.                            |
| `21_until_loop.yml`         | `until`                               | Repeats script until condition (e.g., output = 10).         | Retry a task until success (output contains `10`). Adds resilience to flaky scripts.                               |

---

### ✅ Real-World Analogy

Imagine you're managing laptops for employees:

* `with_items`: Installing the same software on every laptop.
* `with_dict`: Assigning unique usernames and names.
* `with_subelements`: Assigning every team their set of members.
* `with_nested`: Creating default folders for each employee.
* `with_together`: Mapping laptop model to each employee.
* `with_file`: Setting up SSH access from stored key files.
* `with_sequence`: Creating backup folders: `backup_01`, `backup_02`, ...
* `until`: Keep checking if the update server is reachable.

---

### 💬 Sample Interview Questions + Answers

---

**Q: How is `with_items` different from `with_dict`?**

* `with_items`: Iterates over a list (`['a', 'b']`)
* `with_dict`: Iterates over a dictionary (`{'user1': 'James', 'user2': 'Ana'}`)

Use `with_items` when you only care about values. Use `with_dict` when you need both keys and values.

---

**Q: When would you prefer `with_subelements`?**

When you have nested structures – like a family with many members or teams with users. It helps avoid writing multiple loops manually.

Example:

```yaml
families:
  - name: Smith
    members:
      - John
      - Alice
```

---

**Q: Why is `with_nested` useful?**

It allows you to generate all combinations from two lists. E.g., creating a folder structure like:

```bash
/home/john/photos
/home/john/docs
/home/lily/photos
/home/lily/docs
```

---

**Q: What is the difference between `with_together` and `with_nested`?**

* `with_together`: Zips two lists – (`A1`, `B1`), (`A2`, `B2`)
* `with_nested`: All possible combos – (`A1`, `B1`), (`A1`, `B2`), (`A2`, `B1`), etc.

---

**Q: What’s a good use case for `until`?**

Waiting for a service to start. For example, retry `curl http://localhost:8080` until it returns `200 OK` or after 10 tries. Helps avoid flaky failures in automation.

---

