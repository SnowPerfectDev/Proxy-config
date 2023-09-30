#!/bin/bash

# Cores ANSI 
 vermelho="\033[1;31m" 
 verde="\033[1;32m" 
 reset="\033[0m"

# Função para exibir mensagens de sucesso em verde 
 exibir_sucesso() { 
     mensagem="$1" 
     echo -e "${reset}[${verde}+${reset}] ${mensagem}" 
 sleep 2 
 }

# Função para interromper a conexão Tor e sair
function stop_tor() {
    echo "Interrompendo a conexão Tor..."
    pkill tor
    exit 0
}

# Configura o tratamento de Ctrl + C para chamar a função stop_tor
trap stop_tor SIGINT

# Inicia o Tor em segundo plano e redireciona a saída para um arquivo de log
tor > tor.log 2>&1 &

# Exibe uma mensagem de início
echo "Iniciando conexão Tor..."

# Define um tempo limite de inicialização (em segundos)
timeout=60
elapsed=0

while [ $elapsed -lt $timeout ]; do
    # Verifica se o Tor já está conectado no log
    if grep -q "Bootstrapped 100%" tor.log; then
        exibir_sucesso "Conexão Tor estabelecida (100%)"
        break
    else
        # Calcula a porcentagem aproximada de progresso
        progress=$(grep -oE "Bootstrapped [0-9]{1,3}%" tor.log | tail -n1 | grep -oE "[0-9]{1,3}")
        if [ -n "$progress" ]; then
            echo "Progresso: $progress%"
        fi
    fi
    
    sleep 1
    elapsed=$((elapsed+1))
done

# Exemplo de lógica adicional: mantenha o script em execução
echo "O script continuará em execução..."

# Mantém o script em execução indefinidamente (ou até ser interrompido manualmente)
while true; do
    sleep 1
done
