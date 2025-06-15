Perfect! I’ll now create detailed technical notes on **Templating with Jinja2 in Ansible** using your transcript and examples from:

📂 [Templating with Jinja2 - GitHub Repo](https://github.com/ANSANJAY/diveintoansible/tree/master/Ansible%20Playbooks%2C%20Introduction/Templating%20with%20Jinja2)

---

## 📘 Ansible Notes: Templating with Jinja2

Jinja2 is the templating engine Ansible uses to:

* Render dynamic content in playbooks and templates
* Manipulate variables using expressions, conditionals, filters, loops, etc.

---

### ✅ Summary Table

| **Concept**         | **Explanation**                                         | **Example (Revision)**                                              |
| ------------------- | ------------------------------------------------------- | ------------------------------------------------------------------- |
| `if` condition      | Basic condition to match a value                        | Check if host is `ubuntu-c` (rev-01)                                |
| `if-elif-else`      | Covers multiple matching cases and fallback             | Match `ubuntu-c`, `centos1`, else show `ansible_hostname` (rev-03)  |
| `is defined` check  | Validates whether a variable exists                     | Show message only if variable is defined (rev-05)                   |
| `for` loop          | Loop through a list or dictionary                       | Loop through `ansible_interfaces` list (rev-06)                     |
| `range()`           | Generate a range of numbers                             | Use `range(1, 11)` to print 1–10 (rev-07)                           |
| `break`, `continue` | Control flow in loops (with `jinja2_extensions` config) | Skip odd numbers or break at 5 (rev-08, 09)                         |
| `filters`           | Modify or extract values using built-in Jinja2 filters  | `min`, `max`, `unique`, `difference`, `random`, `urlsplit` (rev-10) |
| `template` module   | Render `.j2` template files using variables             | Output templated file to destination (rev-11)                       |

---

### 🧪 Detailed Examples + Explanations

#### 🟩 `if` Condition (rev-01)

```yaml
# jinja2-playbook.yml
- name: Use Jinja2 if condition
  debug:
    msg: "{% if inventory_hostname == 'ubuntu-c' -%} ubuntu-c matched {% endif %}"
```

🔹 Output:
Only `ubuntu-c` will show "ubuntu-c matched".

#### 🟨 `if / elif / else` (rev-02 & rev-03)

```yaml
{% if inventory_hostname == 'ubuntu-c' -%}
  Host is Ubuntu
{% elif inventory_hostname == 'centos1' -%}
  Host is CentOS
{% else -%}
  Host is {{ ansible_hostname }}
{% endif %}
```

🟢 Covers all possibilities.

---

### 🟦 `is defined` (rev-04 & rev-05)

Check if a variable exists:

```yaml
{% if my_var is defined %}
  Variable is defined
{% else %}
  Variable is not defined
{% endif %}
```

🟢 Use `set_fact` before this to define `my_var`.

---

### 🔁 For Loop over List (rev-06)

```yaml
{% for iface in ansible_interfaces %}
  Interface {{ loop.index }}: {{ iface }}
{% endfor %}
```

Loop index is available via `loop.index`.

---

### 🔢 Range Loop (rev-07)

```yaml
{% for i in range(1, 11) %}
  Number: {{ i }}
{% endfor %}
```

🔸 Ends at 10 (not 11).

---

### ⛔ Break & Continue (rev-08, rev-09)

`ansible.cfg`:

```ini
jinja2_extensions = jinja2.ext.do,jinja2.ext.loopcontrols
```

Playbook with `break`:

```yaml
{% for i in range(10, 0, -1) %}
  {% if i == 5 %}
    {% break %}
  {% endif %}
  {{ i }}
{% endfor %}
```

Playbook with `continue`:

```yaml
{% for i in range(1, 11) %}
  {% if i % 2 == 1 %}
    {% continue %}
  {% endif %}
  Even: {{ i }}
{% endfor %}
```

---

### 🧹 Filters (rev-10)

```yaml
# Min
{{ [1,2,3,4,5] | min }}

# Max
{{ [1,2,3,4,5] | max }}

# Unique
{{ [1,1,2,2,3,3,4,4] | unique }}

# Difference
{{ [1,2,3,4,5] | difference([2,3,4]) }}

# Random
{{ ['rod', 'jane', 'freddy'] | random }}

# URL Split
{{ 'https://docs.ansible.com' | urlsplit('hostname') }}
```

---

### 📝 Template Usage (rev-11)

`template-playbook.yml`

```yaml
- name: Render template
  hosts: ubuntu-c
  tasks:
    - name: Use jinja2 template
      template:
        src: template.j2
        dest: /tmp/output.txt
```

`template.j2`:

```jinja
Hello, Hostname: {{ ansible_hostname }}

Filters:
Min: {{ [1,2,3] | min }}
Random Name: {{ ['rod', 'jane', 'freddy'] | random }}
```

---

### 🎯 Real-World Use

* Templating config files (nginx.conf, systemd units, etc.)
* Dynamic playbooks using conditions
* Creating inventory reports
* Looping over items and rendering results into files

---

### 💼 Interview Q\&A

**Q1: What is Jinja2 in Ansible and where is it used?**
**A:** Jinja2 is a templating engine that Ansible uses to render dynamic values. It’s used in playbooks for conditions, loops, filters, and in templates for config file generation.

---

**Q2: How do you check if a variable exists in Jinja2?**
**A:** Use `is defined`:

```jinja
{% if my_var is defined %} ... {% endif %}
```

---

**Q3: How do `break` and `continue` work in Jinja2?**
**A:** They're disabled by default. You must enable `jinja2_extensions = jinja2.ext.loopcontrols` in `ansible.cfg`. Then:

* `break` exits the loop
* `continue` skips to the next iteration

---

**Q4: How are Jinja2 filters useful in Ansible?**
**A:** Filters like `min`, `max`, `unique`, `difference`, `random`, and `urlsplit` help transform data before using it in tasks or templates.

---

**Q5: What's the difference between using Jinja2 in playbooks vs templates?**
**A:**

* In playbooks, Jinja2 is used inline (e.g., `{{ var }}`, conditions, loops)
* In templates, Jinja2 is used to generate full config files using `.j2` files

---

