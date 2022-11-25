#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

double f(double a, double b, double x) {
    return a + b * x * x * x * x;
}

double S(double a, double b, int A, int B) {
    int n = 100000000;
    double h = (float) (B - A) / n;
    double sum = 0.0;
    for (int i = 0; i < n; i++) {
        sum += f(a, b, A + i * h);
    }
    return h * sum;
}

int main(int argc, char *argv[]) {
    if ((argc != 2) && (argc != 4) && (argc != 3)) {
        printf("Некорректный ввод!\n");
        return 0;
    }
    clock_t start, end;
    if (strcmp(argv[1], "-r") == 0) {
        if (argc != 3) {
            printf("Некорректный ввод!\n");
            return 0;
        }
        srand(time(NULL));
        FILE *out = fopen(argv[2], "w");
        if ((out == NULL)) {
            printf("файл некорректный, либо не существует!\n");
            return 0;
        }
        double a = (rand() % 10);
        double b = (rand() % 15);
        int A = (rand() % 15 - 10);
        int B = (rand() % 15);
        fprintf(out, "random numbers: a = %lf, b = %lf, A = %d, B = %d\n", a, b, A, B);
        start = clock();
        double s = S(a, b, A, B);
        end = clock();
        fprintf(out, "root: %lf\ntime: %.4lf\n", s, (double) (end - start) / (CLOCKS_PER_SEC));
        fclose(out);
    } else if (strcmp(argv[1], "-h") == 0) {
        printf("\n-h вывести справку\n");
        printf("-r Создать случайные коэффициенты и границы\n");
        printf("-f считать данные из input.txt и записать результат в output.txt\n");
        printf("-s Считать данные из терминала и записать в файл.\n");
    } else if (strcmp(argv[1], "-f") == 0) {
        if (argc != 4) {
            printf("Некорректный ввод!\n");
            return 0;
        }
        FILE *input = fopen(argv[2], "r");
        FILE *out = fopen(argv[3], "w");
        if ((input == NULL) || (out == NULL)) {
            printf("Файл некорректный, либо не существует!\n");
            return 0;
        }
        double a, b;
        int A, B;
        fscanf(input, "%lf", &a);
        fscanf(input, "%lf", &b);
        fscanf(input, "%d", &A);
        fscanf(input, "%d", &B);
        start = clock();
        double s = S(a, b, A, B);
        end = clock();
        fprintf(out, "integral = %lf\ntime: %.4lf\n", s, (double) (end - start) / (CLOCKS_PER_SEC));
        fclose(input);
        fclose(out);
    } else if ((strcmp(argv[1], "-s") == 0)) {
        if (argc != 3) {
            printf("Некорректный ввод!\n");
            return 0;
        }
        FILE *out = fopen(argv[2], "w");
        if ((out == NULL)) {
            printf("Файл некорректный, либо не существует!\n");
            return 0;
        }
        double a, b;
        int A, B;
        scanf("%lf", &a);
        scanf("%lf", &b);
        scanf("%d", &A);
        scanf("%d", &B);
        start = clock();
        double s = S(a, b, A, B);
        end = clock();
        fprintf(out, "integral = %lf\ntime: %.4lf\n", s, (double) (end - start) / (CLOCKS_PER_SEC));
        fclose(out);
    }
    return 0;
}

