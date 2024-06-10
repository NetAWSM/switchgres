import os, psycopg2, subprocess


def check_status(): # Проверка работы postgres

    stat = subprocess.call(["systemctl", "is-active", "--quiet", "postgresql-14"])
    if(stat == 0):
        return 0
    else:
        return 1

def check_slave():

    connection = psycopg2.connect(user="a001-backup",
                                  password="backup",
                                  host="192.168.118.134",
                                  port="5432",
                                  database="postgres")
    
    cursor = connection.cursor()
    get_select = "SELECT pg_is_in_recovery()"
    cursor.execute(get_select)
    check = cursor.fetchall()
    
    for i in check:
        return i[0]


def check_consistency():
    pass



def main():
    if  check_status() == 0:
        if check_slave() == True:
            print("Это слейв")
        elif check_slave() == False:
            print("Это мастер")
        else:
            print("Некорректный адрес")

main()
