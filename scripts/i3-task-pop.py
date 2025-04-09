#!/usr/bin/env python3
import subprocess
import os
import re
from datetime import datetime

TASK_FILE = os.path.expanduser("~/scripts/tasks.txt")

# --------- Funções de tarefas ---------

def carregar_tarefas():
    if not os.path.exists(TASK_FILE):
        return []
    with open(TASK_FILE, "r") as f:
        return [linha.strip() for linha in f if linha.strip()]

def salvar_tarefas(tarefas):
    with open(TASK_FILE, "w") as f:
        f.write("\n".join(tarefas) + "\n")

def parse_tarefa(tarefa):
    # Extrai prioridade, data, tags e descrição
    prioridade = re.search(r"^\(([A-Z])\)", tarefa)
    data = re.search(r"\d{4}-\d{2}-\d{2}", tarefa)
    tags = re.findall(r"@\w+", tarefa)
    concluida = tarefa.startswith("x ")

    return {
        "texto": tarefa,
        "prioridade": prioridade.group(1) if prioridade else None,
        "data": data.group(0) if data else None,
        "tags": tags,
        "concluida": concluida
    }

def filtrar_tarefas(tarefas, chave, valor):
    return [t for t in tarefas if parse_tarefa(t)[chave] == valor]

def filtrar_por_tag(tarefas, tag):
    return [t for t in tarefas if tag in parse_tarefa(t)["tags"]]

# --------- Funções auxiliares ---------

def rofi_menu(opcoes, prompt="Escolha:"):
    menu = "\n".join(opcoes)
    result = subprocess.run(
        ["rofi", "-dmenu", "-p", prompt],
        input=menu.encode(),
        stdout=subprocess.PIPE
    )
    return result.stdout.decode().strip()

def adicionar_tarefa():
    texto = rofi_menu(["Digite a nova tarefa (ex: (A) Estudar Python @programacao 2025-04-04)"], "Nova tarefa:")
    if texto:
        tarefas = carregar_tarefas()
        tarefas.append(texto)
        salvar_tarefas(tarefas)

def concluir_tarefa():
    tarefas = [t for t in carregar_tarefas() if not parse_tarefa(t)["concluida"]]
    if not tarefas:
        subprocess.run(["notify-send", "Sem tarefas para concluir."])
        return
    escolha = rofi_menu(tarefas, "Concluir tarefa:")
    if escolha and escolha in tarefas:
        tarefas[tarefas.index(escolha)] = f"x {escolha}"
        salvar_tarefas(tarefas)

def remover_tarefa():
    tarefas = carregar_tarefas()
    if not tarefas:
        subprocess.run(["notify-send", "Nenhuma tarefa encontrada."])
        return
    escolha = rofi_menu(tarefas, "Remover tarefa:")
    if escolha and escolha in tarefas:
        tarefas.remove(escolha)
        salvar_tarefas(tarefas)

def ver_tarefas():
    tarefas = [t for t in carregar_tarefas() if not parse_tarefa(t)["concluida"]]
    if not tarefas:
        subprocess.run(["notify-send", "Sem tarefas pendentes."])
        return
    rofi_menu(tarefas, "Tarefas pendentes")

def filtrar_tarefas_menu():
    filtro = rofi_menu(["Por prioridade", "Por tag", "Por data"], "Filtrar por:")
    tarefas = carregar_tarefas()
    if filtro == "Por prioridade":
        prioridade = rofi_menu(["A", "B", "C"], "Prioridade:")
        tarefas_filtradas = filtrar_tarefas(tarefas, "prioridade", prioridade)
    elif filtro == "Por tag":
        tag = rofi_menu(["@programacao", "@trabalho", "@saude", "@filosofia"], "Tag:")
        tarefas_filtradas = filtrar_por_tag(tarefas, tag)
    elif filtro == "Por data":
        data = rofi_menu(["Digite a data (ex: 2025-04-04)"], "Data:")
        tarefas_filtradas = filtrar_tarefas(tarefas, "data", data)
    else:
        return

    if tarefas_filtradas:
        rofi_menu(tarefas_filtradas, "Filtradas:")
    else:
        subprocess.run(["notify-send", "Nenhuma tarefa encontrada."])

# --------- Menu Principal ---------

def menu_principal():
    opcoes = [
        "1. Ver tarefas",
        "2. Adicionar tarefa",
        "3. Concluir tarefa",
        "4. Remover tarefa",
        "5. Filtrar tarefas"
    ]
    escolha = rofi_menu(opcoes, "Menu de Tarefas")
    
    if escolha.startswith("1"):
        ver_tarefas()
    elif escolha.startswith("2"):
        adicionar_tarefa()
    elif escolha.startswith("3"):
        concluir_tarefa()
    elif escolha.startswith("4"):
        remover_tarefa()
    elif escolha.startswith("5"):
        filtrar_tarefas_menu()

if __name__ == "__main__":
    menu_principal()

