# Valhalla

Este projeto fornece uma **base modular** para servidores FiveM, com o objetivo de facilitar o desenvolvimento de servidores.

## 🚀 **Recursos**

- Gerenciamento de Jogadores
- Grupos e Permissões
- Economia

## 📥 **Instalação**

### 1. Clone o Repositório

```bash
git clone https://github.com/extraplays/valhalla.git
```

### 2. Instale as Dependências

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)

### 3. Configurar o Banco de Dados

Crie um banco de dados com o nome `valhalla`

```sql
CREATE DATABASE valhalla;
```

### 4. Importar o Schema

Importe o arquivo `valhalla.sql` para o banco de dados

### 5. Configurar o Servidor

Configure o arquivo `server.cfg` para carregar os módulos necessários

```cfg
ensure oxmysql
ensure ox_lib
ensure valhalla
```

## 📚 **Documentação**

A documentação completa do projeto está disponível em [extraplays.com/docs/valhalla](https://extraplays.com/docs/valhalla)
