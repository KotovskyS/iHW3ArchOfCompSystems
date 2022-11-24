## Архитектура вычислительных систем
### Индивидуальное домашнее задание №3
##### Вариант 28


##### Котовский Семен Олегович, БПИ219
24 ноября 2022 г.



<b>Задание</b>: Разработать программу численного интегрирования функции y = a + b * x^4 (Задаётся действительными числами a,b) в определенном диапазоне целых (задаётся так же) методом прямоугольников с избытком (точность вычислений = 0.0001).

## Отчёт о выполнении

#### 4	балла
Задача решена на 8 баллов, но все изменения на предыдущие оценки содержатся в итоговых файлах.
<li>	Приведено решение задачи на C.</li>

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
double f(double a, double b, double x){
  return a + b * x * x * x * x;
}

double S(double a, double b, int A, int B){
  int n = 100000000;
  double h = (float)(B - A) / n;
  double sum = 0.0;
  for(int i = 0; i < n; i++){
    sum += f(a, b, A + i * h);
  }
  return h * sum;
}

int main(int argc, char *argv[]) {
  if((argc != 2) && (argc != 4)&& (argc != 3)){
    printf("Incrorrect input, check README.md\n");
    return 0;
  }
  clock_t start, end;
  if(strcmp(argv[1], "-r") == 0){
    if(argc != 3){
      printf("Incrorrect input, check README.md\n");
      return 0;
    }
    srand(time(NULL));
    FILE *out = fopen(argv[2], "w");
    if((out == NULL)){
      printf("incorrect file\n");
      return 0;
    }
    double a = (rand()%10);
    double b = (rand()%15);
    int A = (rand()%15 - 10);
    int B = (rand()%15);
    fprintf(out, "random numbers: a = %lf, b = %lf, A = %d, B = %d\n", a, b, A, B);
    start = clock();
    double s = S(a, b, A, B);
    end = clock();
    fprintf(out, "root: %lf\ntime: %.4lf\n", s, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(out);
  }
  else if(strcmp(argv[1], "-h") == 0){
    printf("\n-h help\n");
    printf("-r create random numbers (a, b, A, B)\n");
    printf("-f use numbers from first file and save result in second file\n");
    printf("-s take numbers from terminal and print result in file\n");
  }
  else if(strcmp(argv[1], "-f") == 0){
    if(argc != 4){
      printf("Incrorrect input, check README.md\n");
      return 0;
    }
    FILE *input = fopen(argv[2], "r");
    FILE *out = fopen(argv[3], "w");
    if((input == NULL) || (out == NULL)){
      printf("incorrect file\n");
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
    fprintf(out, "integral = %lf\ntime: %.4lf\n", s, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(input);
    fclose(out);
  }
  else if((strcmp(argv[1], "-s") == 0)){
    if(argc != 3){
      printf("Incrorrect input, check README.md\n");
      return 0;
    }
    FILE *out = fopen(argv[2], "w");
    if((out == NULL)){
      printf("incorrect file\n");
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
    fprintf(out, "integral = %lf\ntime: %.4lf\n", s, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(out);
  }
  return 0;
}


```

Код находится в файле 8.c
Далее в командную строку вводим данные команды для получения искомого ассемблерного файла, а также исполняемого файла.
$gcc -O0 -Wall -fno-asynchronous-unwind-tables 8.c -o main
$gcc -O0 -Wall -fno-asynchronous-unwind-tables -S 8.c -o 8.s
$gcc 8.s -o
Необходимые комментарии находятся в 8.s

![img](Screenshot1.png)

Представлено полное тестовое покрытие, дающее одинаковый результат на обоих программах.
После тестирования программ можно сделать вывод, что работа программы является корректной и эквивалентной.
<br>Примечание: для краткости в выводе не указаны слова lowercase и uppercase. Сначала выведено количество строчных, а затем прописных символов.
<br><br>
#### 5	баллов
<br>
В дополнение к требованиям на предыдущую оценку

•	В реализованной программе я использовал функции с передачей данных через параметры.
Функция counter принимает на вход указатель на начало строки, длину строки,
а также переменные, в которые будет сохранено количество строчных и заглавных символов.
Внутри функции реализован подсчёт количества соответствующих символов.

```c
#include <stdio.h>
#include <stdlib.h>

char *get_string(int *len, int *test) {
    *len = 0; 
    *test = 0;
    int capacity = 1; 
    char *s = (char*) malloc(sizeof(char)); 
    char c = getchar();
    if(c > 127){
      (*test)++;
    }  
    while (c != '\n') {
        s[(*len)++] = c; 
        if (*len >= capacity) {
            capacity *= 2; 
            s = (char*) realloc(s, capacity * sizeof(char)); 
        }

        c = getchar();
	if(c > 127){
          (*test)++;
        }          
    }
    s[*len] = '\0'; 
    return s; 
}
void counter(char *s, int len, int *a, int *A){
    for(int i = 0; i < len;i++){
        if((s[i] >= 65) && (s[i] <= 90)){
          (*A)++;
        }
        else if((s[i] >= 97) && (s[i] <= 122)){
          (*a)++;
        }
    }
}
int main() {
    int len, test; 
    int a = 0;
    int A = 0;
    char *s = get_string(&len, &test);
    if(test == 0){
      counter(s, len, &a, &A);
      printf("lowercase: %d \nuppercase %d\n", a, A);
      return 0; 
    }
    else{
      printf("incorrect input");
      return 0;
    }
    free(s); 
    return 0;
}
```

Измененная программа была сохранена в файле 5.c

##### Функциональность:
●	get_string(int *len, int *test) - получает на вход длину строки и переменную для проверки правильности ввода.
Внутри метода происходит проверка правильности ввода. Функция возвращает строку.

●	counter(char *s, int len, int *a, int *A) - получает на вход указатель на строку,
длину строки и переменные, в которых будет храниться количество строчных и прописных
букв. В функции подсчитывается количество соответствующих символов и записывается в соответствующие переменные.

##### Комментарии:
В ассемблерную программу при вызове функций были добавлены
комментарии, которые описывают передачу фактических параметров и перенос возвращаемого результат, в случае когда функция ничего не возвращает был добавлен комментарий (void)
В этой программе не использовались формальные параметры.

#### 6 баллов
В дополнение к требованиям на предыдущую оценку
Я сделал рефакторинг программы на ассемблере за счет максимального использования регистров процессора. Измененная программа сохранена в файле “6.s”. В процессе рефакторинга соотвественно были изменены команды (например movl -> movq), а также были изменены регистры, которые контактировали с “новыми” регистрами (например: movl eax, -24(%rbp) -> movq rax, r12).
Также были добавлены комментарии, которые поясняют использование регистров в соответствии с переменными из исходной программы на С.

![img](screenshot2.png)

Представлено полное тестовое покрытие, дающее одинаковый результат на всех программах.

#### 7 баллов

Реализация программы на ассемблере, полученной после рефакторинга, в виде двух единиц компиляции (6-1.s & 6-2.s).

Я разделил код ассемблера на файл с функциями и файл с main. Далее скомпилировал полученные файлы и запустил файлы с исходными данными и файла для вывода результатов с использованием аргументов командной строки.

Далее я переделал файл Си, чтобы он брал и записывал данные из вводимых в командную строку файлов. (int argc, char * argv[]) измененная программа была сохранена под названием “7.c”


После чего эта программа была скомпилирована в 7.s.

#### 8 баллов

• В программу добавлен функционал для генерации случайных наборов данных.

Для корректной работы программы, запускать её необходимо с указанием одного из ключей (-h, -r, -f, -s)


Пример работы случайной генерации:
![img](screenshot5.png)

• Также реализована навигация в командной строке с выбором требуемых функций:
![img](screenshot3.png)
```c
else if(strcmp(argv[1], "-h") == 0){
    printf("-h Список функций\n");
    printf("-r Сгенерировать случайную строку\n");
    printf("-f считать входные данные из input.txt и вывести результат в output.txt\n");
    printf("-s считать строку из терминала и вывести в него результат\n");
  }
```

• Программа была модифицирована добавлением функционала для вычисления времени.
![img](screenshot4.png)

Время работы программы было увеличено при помощи искусственного выполнения цикла множественное число раз.

```c
void counter(char *s, int len, int *a, int *A){
	for(int j = 0; j < 100000;j++){
	  *a = 0;
	  *A = 0;
	  for(int i = 0; i < len;i++){
		if((s[i] >= 65) && (s[i] <= 90)){
		  (*A)++;
		}
		else if((s[i] >= 97) && (s[i] <= 122)){
		  (*a)++;
		}
	    }
	}
}
```

Финальная версия программы сохранена в 8.c
