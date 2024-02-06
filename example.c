extern void externalFunction();

void localFunction() {
    /* printf("External function\n"); */
}

int main() {
    // local
    int localVariable = 42;

    // local call
    localFunction();

    // external call
    externalFunction();

    // using of external var
    /* printf("Value of localVariable: %d\n", localVariable); */

    return 0;
}
