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
print(">>> \t1.3.0")

ConsoleHeader = "Console"
con = None
session = None

while(True):

    myHeader(ConsoleHeader)
    command = input()

    if command == 'exit' or command == 'q' or command == 'quit':

        if session != None:
            print("(%s) >> Terminando a sessão atual." % command)
            session.close()

        if con != None:
            print("(%s) >> Fechando a conexão atual." % command)
            con.close()

        print("(%s) >> Terminando o programa." % command)
        exit()

    if command == 'cls' or command == 'clear':
        os.system("cls")
        continue
    
    if command == 'help' or command == 'h':
        print('')
        print("Comandos:")
        print("\texit, quit, q\t:\tSair do programa.")
        print("\thelp, h      \t:\tAjuda e comandos.")
        print("\tclear, cls   \t:\tLimpar o console.")
        print("\tlogin        \t:\tLogin em uma database.")
        print("\tlogout       \t:\tLogout de volta para o console.")
        print("\tinsert       \t:\tInserir na database logada.")
        print("\tquery        \t:\tConsulta na database logada.")
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

        str_database = db
        db = user + " @ " + db
        ConsoleHeader = db
        continue
    
    if command == 'logout':
        if con == None:
            print("(%s) >> " % ConsoleHeader + "Não há conexão estabelecida.")
            continue

        if session != None:
            session.close()
            session = None

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
        ConsoleHeader = "Insert @ " + str_database

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

        # INSERT na database: Turista recém-cadastrado
        # essa é a forma de inserção recomendada pelo psycopg2 (https://www.psycopg.org/docs/usage.html)
        try:
            session.execute("INSERT INTO Turista (PaisOrigem, NumPassaporte, Nome, DataNascimento, Telefone, Email, Senha) values (%s, %s, %s, %s, %s, %s, %s)",
            (PaisOrigem, NumPassaporte, Nome, DataNascimento, Telefone, Email, Senha))
        except Exception:
            myHeader(ConsoleHeader)
            print("PSQL: não foi possível fazer a inserção.")       
    
        con.commit()
        session.close()
        ConsoleHeader = db
        continue
        

    if command == 'query':
        if con == None:
            print("(%s) >> " % ConsoleHeader + "Não há conexão estabelecida.")
            continue

        session = con.cursor()
        ConsoleHeader = "Query @ " + str_database
        myHeader(ConsoleHeader)
        print("Listar todos os turistas que participam de um Festival.")
        myHeader(ConsoleHeader)
        festival = input("Nome do festival: ")

        # Query na database: Turistas a partir de um festival
        # essa é outra forma de formatação de queries recomendada pelo psycopg2
        try:
            session.execute("""SELECT DISTINCT T.Nome, T.NumPassaporte, I.PaisTurista as paisOrigem
                               FROM Ingresso I, Turista T
                               WHERE I.PaisTurista = T.PaisOrigem 
                               AND I.TuristaPassaporte = T.NumPassaporte 
                               AND I.Festival = ( SELECT IdFiscal 
                                                  FROM Festival 
                                                  WHERE Nome = (%s));""", [festival])
        except Exception:
            myHeader(ConsoleHeader)
            print("PSQL: não foi possível fazer a consulta.")
            session.close()
            ConsoleHeader = db
            continue

        # fetchall() retorna uma tupla com os resultados da sessão
        rows = session.fetchall()

        if len(rows) == 0: # tupla vazia
            myHeader(ConsoleHeader)
            print("A consulta não obteve resultados.")
            ConsoleHeader = db
            continue

        for i in rows:
            print('')
            print(f"Nome: {i[0]}")
            print(f"Passaporte: {i[1]}")
            print(f"País de Origem: {i[2]}")

        session.close()
        ConsoleHeader = db
        continue


    if command == '':
        continue

    myHeader(ConsoleHeader)
    print("Comando '%s' desconhecido. Para comandos digite help" % command)        
    
