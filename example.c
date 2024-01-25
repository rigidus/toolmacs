// Внешняя функция
extern void externalFunction();

void localFunction() {
    /* printf("External function\n"); */
}

int main() {
    // Локальная переменная
    int localVariable = 42;

    // Вызов локальной функции
    localFunction();

    // Вызов внешней функции
    externalFunction();

    // Использование внешней переменной
    /* printf("Value of localVariable: %d\n", localVariable); */

    return 0;
}
