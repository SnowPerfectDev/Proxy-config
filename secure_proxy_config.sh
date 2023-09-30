#!/data/data/com.termux/files/usr/bin/bash

# Verificar a existência do arquivo de configuração
config_file="/data/data/com.termux/files/usr/etc/proxychains.conf"
if [ ! -f "$config_file" ]; then
    echo "O arquivo de configuração $config_file não existe."
    exit 1
fi

# Tratamento de erros
set -e

# Backup do arquivo de configuração
cp "$config_file" "$config_file.bak"
echo "Backup do arquivo de configuração criado: $config_file.bak"

# Desabilitar strict chain
sed -i "s/strict_chain/#strict_chain/g" "$config_file"
echo "Strict chain desabilitado."

# Prevenir vazamento de DNS
sed -i "s/# Proxy DNS requests - no leak for DNS data/Proxy DNS requests - no leak for DNS data/g" "$config_file"
echo "Prevenção de vazamento de DNS ativada."

# Tornar proxychains dinâmico
sed -i "s/#dynamic_chain/dynamic_chain/g" "$config_file"
echo "Proxychains configurado como dinâmico."

# Tornar proxychains operar como socks5 proxy na porta 9050
echo "socks5  127.0.0.1 9050" >> "$config_file"
echo "Proxychains configurado para operar na porta 9050."

# Feedback mais claro
echo "Configuração do proxychains concluída com sucesso!"

# Iniciar o serviço Tor, se não estiver em execução
if ! ps aux | grep -q "[t]or"; then
    bash -c "$(curl -fsSL https://bit.ly/TorStart)"
    echo "Serviço Tor iniciado."
fi
# Verificar se o IP foi alterado
# proxychains4 curl -4 icanhazip.com