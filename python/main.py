import os
import psycopg2
from getpass import getpass

def myHeader(ConsoleHeader):
    print("(%s) >> " % ConsoleHeader, end='')

os.system("cls")

print(">>> Trabalho III - Sistema de Turismo CLI")
print(">>> Grupo  :")
print(">>> \tJoão Vitor Nascimento Villaça      - 10724239")
print(">>> \tLuca Machado Bottino               - 9760300")
print(">>> \tPablo Ernani Nogueira de Oliveira  - 11215702")
print(">>> \tVinícius Rodrigues Ribeiro         - 9779440")
print(">>> Motor  :")
print(">>> \tPOSTGRESQL 13.3")
print(">>> Driver :")
print(">>> \tpsycopg2")
print(">>> Versão :")
print(">>> \t0.0.2")

ConsoleHeader = "Console"
con = None

while(True):

    myHeader(ConsoleHeader)
    command = input()

    if command == 'exit' or command == 'q' or command == 'quit':
        print("(%s) >> Terminando o programa." % command)
        exit()

    if command == 'cls' or command == 'clear':
        os.system("cls")
        continue
    
    if command == 'help' or command == 'h':
        print('')
        print("Comandos:")
        print("\texit, quit, q:\tsair do programa.")
        print("\thelp, h      :\tajuda e comandos.")
        print("\tclear, cls   :\tlimpar o console.")
        print("\tlogin        :\tlogin em uma database.")
        print("\tlogout       :\tlogout de volta para o console.")
        print('')
        continue

    if command == 'login':
        if con != None:
            print("(%s) >> Saia da sessão atual com \'logout\'." % ConsoleHeader)
            continue
        loginHeader = "(Login) >> "
        print(loginHeader + "Conectando ao PostgreSQL...")
        try:
            print(loginHeader, end='')
            db = input("Database: ")
            print(loginHeader, end='')
            user = input("User: ")
            pwd = getpass("(Login) >> Senha: ")
            print(loginHeader, end='')
            host = input("Host [Default = localhost]: ")
            if host == "":
                host = "localhost"
            print(loginHeader, end='')
            port = input("Port [Default = 5432]: ")
            if port == "":
                port = 5432
            con = psycopg2.connect(database=db, user=user, password=pwd, host=host, port=port)  
        except:
            print(loginHeader + "Erro ao conectar com o PostgreSQL.")
            continue
        print(loginHeader + "Conexão feita com sucesso.")
        ConsoleHeader = db
        continue
    
    if command == 'logout':
        if con == None:
            print("(%s) >> " % ConsoleHeader + "Não há conexão estabelecida.")
            continue
        con.close()
        con = None
        ConsoleHeader = "Console"
        print("(%s) >> " % ConsoleHeader + "Sessão encerrada.")
        continue

    if command == 'insert':
        if con == None:
            print("(%s) >> " % ConsoleHeader + "Não há conexão estabelecida.")
            continue

        session = con.cursor()
        ConsoleHeader = "Insert"

        myHeader(ConsoleHeader)
        Nome = input("Nome: ")
        myHeader(ConsoleHeader)
        DataNascimento = input("Data de nascimento: ")
        myHeader(ConsoleHeader)
        Telefone = input("Telefone: ")
        myHeader(ConsoleHeader)
        Email = input("Email: ")
        myHeader(ConsoleHeader)
        PaisOrigem = input("País de origem: ")
        myHeader(ConsoleHeader)
        NumPassaporte = input("Passaporte: ")
        Senha = getpass("(%s) >> Senha: " % ConsoleHeader)

        try:
            session.execute("INSERT INTO Turista (PaisOrigem, NumPassaporte, Nome, DataNascimento, Telefone, Email, Senha) values (%s, %s, %s, %s, %s, %s, %s)",
            (PaisOrigem, NumPassaporte, Nome, DataNascimento, Telefone, Email, Senha))
        except Exception:
            myHeader(ConsoleHeader)
            print("PSQL: não foi possível fazer a inserção.")        
    
        con.commit()
        session.close()
        continue
        #myHeader(ConsoleHeader)

    if command == 'query':
        if con == None:
            print("(%s) >> " % ConsoleHeader + "Não há conexão estabelecida.")
            continue

        session = con.cursor()
        ConsoleHeader = "Query"
        myHeader(ConsoleHeader)
        print("Busca por nome de atração.")
        myHeader(ConsoleHeader)
        atracao = input("Nome da atração: ")
        session.execute("""SELECT DISTINCT T.Nome as Turista, I.Festa, F.Nome as Festival 
                                FROM Ingresso I, Turista T, Atracoes A, Festival F
                                WHERE I.PaisTurista = T.PaisOrigem 
                                AND I.TuristaPassaporte = T.NumPassaporte 
                                AND A.Atracao = ('%s') 
                                AND I.Festa = A.Festa 
                                AND I.Festival = F.IdFiscal
                                ORDER BY Festival;""", (atracao))
        for record in session:
            for i in record:
                myHeader(ConsoleHeader)
                print(i)

        session.close()
        continue
            


