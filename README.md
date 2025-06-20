# Cursor GNOME Update

Instala e atualiza o Cursor IDE no GNOME com um comando.

## 🚀 Instalação Rápida

**Uma linha:**

```bash
curl -fsSL https://raw.githubusercontent.com/Muriel-Gasparini/cursor-gnome-update/main/install | bash
```

**Usar:**

```bash
update-cursor
```

**Desinstalar:**

```bash
update-cursor --uninstall
```

## 🛠️ Instalação Manual

```bash
git clone https://github.com/Muriel-Gasparini/cursor-gnome-update.git
cd cursor-gnome-update
./setup.sh
```

## 🎯 O que faz

- **Primeira execução**: Instala o Cursor completamente
- **Próximas execuções**: Apenas atualiza
- **Integração GNOME**: Ícone + menu automaticamente

## 📋 Requisitos

- Linux + GNOME
- `curl`, `jq`, `sudo`

---

**Autor:** Muriel Gasparini  
**Licença:** MIT
