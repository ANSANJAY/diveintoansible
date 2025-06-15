## 🔐 Topic: Ansible Vault – Secure Secret Management

### ✅ What Is Ansible Vault?

Ansible Vault is a built-in tool to **secure sensitive data** like passwords, API tokens, or private keys.
It encrypts:

* Individual variables (`encrypt_string`)
* Entire files (`encrypt`)
* Entire playbooks (`encrypt`)
  …and allows selective access via **vault IDs** or password files.

---

## 💼 Real-World Usage: How It's Used in Production

| Scenario                  | Use Case                                                            | Vault Technique         |
| ------------------------- | ------------------------------------------------------------------- | ----------------------- |
| Secure `sudo` password    | Use `ansible_become_pass` securely                                  | `encrypt_string`        |
| Manage AWS secrets        | Encrypt entire `group_vars/aws.yml`                                 | `ansible-vault encrypt` |
| Rotate secrets monthly    | Use `ansible-vault rekey` to update passwords                       |                         |
| Multi-team secrets        | Use `--vault-id team1@prompt` and `team2@prompt` to separate access |                         |
| CI/CD with GitHub Actions | Use `--vault-password-file` in automation scripts                   |                         |
| Full encryption           | Encrypt `site.yml` in regulated environments                        |                         |

---

## 🧪 Key Commands and Examples

### 🔹 1. Encrypt a single variable (e.g., sudo password)

```bash
ansible-vault encrypt_string --ask-vault-pass \
  --name 'ansible_become_pass' 'password'
```

**Output added to `group_vars/ubuntu.yml`:**

```yaml
ansible_become_pass: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          64363234333338616134306533666539666330653535363666386637383533353335376435323432
```

---

### 🔹 2. Encrypt a full variable file

```bash
ansible-vault encrypt vars/external_vault_vars.yml
```

### 🟢 Playbook Usage:

```yaml
# site.yml
- hosts: all
  become: yes
  vars_files:
    - vars/external_vault_vars.yml
  tasks:
    - name: Print secured variable
      debug:
        var: secret_key
```

### 🔹 Run the playbook:

```bash
ansible-playbook site.yml --ask-vault-pass
```

---

### 🔹 3. Decrypt the file

```bash
ansible-vault decrypt vars/external_vault_vars.yml
```

---

### 🔹 4. Rotate secret password (rekey)

```bash
ansible-vault rekey vars/external_vault_vars.yml
# prompts old password, then new password
```

---

### 🔹 5. View without decrypting

```bash
ansible-vault view vars/external_vault_vars.yml
```

---

### 🔹 6. Use password from file (CI/CD safe)

```bash
ansible-playbook site.yml \
  --vault-password-file password_file.txt
```

---

### 🔹 7. Named Vaults

```bash
ansible-vault encrypt --vault-id vars@prompt vars/external_vault_vars.yml
ansible-vault encrypt_string --vault-id ssh@prompt --name ansible_become_pass 'password'
```

### 🟢 Playbook Execution with multiple vaults:

```bash
ansible-playbook site.yml \
  --vault-id vars@prompt \
  --vault-id ssh@prompt
```

---

### 🔹 8. Encrypt Entire Playbook

```bash
ansible-vault encrypt site.yml --vault-id playbook@prompt
```

### 🟢 Run with all vaults:

```bash
ansible-playbook site.yml \
  --vault-id vars@prompt \
  --vault-id ssh@prompt \
  --vault-id playbook@prompt
```

---

## 📘 GitHub Repo Summary

| Revision | Feature                      | Files                          |
| -------- | ---------------------------- | ------------------------------ |
| 01       | Encrypt individual var       | `group_vars/ubuntu.yml`        |
| 02       | Encrypt full var file        | `vars/external_vault_vars.yml` |
| 03       | Rekey example                | `ansible-vault rekey`          |
| 04       | Password file automation     | `password_file.txt`            |
| 05       | Named vaults                 | `--vault-id vars@prompt`       |
| 06       | Multiple vaults in same play | `site.yml`, group\_vars        |
| 07       | Encrypted playbook execution | `site.yml` (fully encrypted)   |

Repo:
📂 [ANSANJAY/diveintoansible → Vault](https://github.com/ANSANJAY/diveintoansible/tree/master/Ansible%20Playbooks%2C%20Deep%20Dive/Vault)

---

## 🎯 Interview Questions + Sample Answers

### 1. What is Ansible Vault and why would you use it?

**Answer:** It's a tool for encrypting sensitive data like passwords or API keys. I’ve used it to secure `ansible_become_pass` and external var files in my playbooks, avoiding secrets in plaintext.

---

### 2. How do you manage multiple vault passwords?

**Answer:** Using `--vault-id name@prompt` I separate access. One vault might store database credentials, another stores OS-level passwords. This enables security boundaries in multi-team environments.

---

### 3. Can you automate Vault in pipelines?

**Answer:** Yes. I use `--vault-password-file` to securely read passwords from pre-secured files in CI/CD systems. This avoids prompting and allows automation.

---

### 4. Describe your approach to secret rotation.

**Answer:** I’ve used `ansible-vault rekey` to rotate vault passwords. It's useful during team transitions or quarterly audits.

---

### 5. Can you encrypt entire playbooks?

**Answer:** Yes, I’ve used `ansible-vault encrypt site.yml`. At runtime, I pass the vault password using `--vault-id`.

---

## 🧠 Analogy to Remember

> Think of Ansible Vault as a **locker room**. You can lock:
>
> * One locker (a variable)
> * A suitcase (a file)
> * The whole room (a playbook)
>   And access depends on **which key** (vault-id or file) you have.

---

Would you like this converted into a Markdown file for GitHub or into a PDF for documentation or interviews?
