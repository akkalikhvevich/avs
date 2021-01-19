#include <stdio.h>   
#include <pthread.h>
#include <stdbool.h>
#include <stdlib.h>

FILE* fin;
FILE* fout;
const int arrSize = 10000;
int firstArray[10000];
int firstSize;
int secondArray[10000];
int secondSize = 0;

int CArray[10000];
int CSize = 0;

void* Union(void* param) {

	int k = firstSize;
	int l = secondSize;

	int m3[10000];
	int n = 0;
	int i = 0, j = 0;
	while ((i < k) && (j < l)) {
		if (firstArray[i] < secondArray[j])
			m3[n++] = firstArray[i++];
		else if (secondArray[j] < firstArray[i])
			m3[n++] = secondArray[j++];
		else {
			m3[n++] = firstArray[i++];
			++j;
		}
		while (i < k)
			m3[n++] = firstArray[i++];
		while (j < l)
			m3[n++] = secondArray[j++];
	}
	fprintf(fout, "\n Совпадает ли множество С с объедиением А и В : %d\n", IsSame(m3, n, CArray, CSize));
}
void* Diff_AB(void* param) {


	int m3[10000];
	int n3;

	bool isRepeat;
	n3 = 0;
	for (int i = 0; i < firstSize; ++i)
	{
		isRepeat = false;
		for (int j = 0; j < secondSize; ++j)     //Поиск среди второго "множества" 
			if (firstArray[i] == secondArray[j])      //если элементы равны
			{
				isRepeat = true;       //продолжаем итерацию цикла
				break;
			}


		if (isRepeat == false)
			m3[n3++] = (firstArray[i]);
	}
	fprintf(fout, "\n Совпадает ли множество С с разностью А и В : %d\n", IsSame(m3, n3, CArray, CSize));

}
void* Diff_BA(void* param) {


	int m3[10000];
	int n3;

	bool isRepeat;
	n3 = 0;
	for (int i = 0; i < secondSize; ++i)
	{
		isRepeat = false;
		for (int j = 0; j < firstSize; ++j)     //Поиск среди второго "множества" 
			if (secondArray[i] == firstArray[j])      //если элементы равны
			{
				isRepeat = true;       //продолжаем итерацию цикла
				break;
			}


		if (isRepeat == false)
			m3[n3++] = (secondArray[i]);
	}
	fprintf(fout, "\n Совпадает ли множество С с разностью В и А : %d\n", IsSame(m3, n3, CArray, CSize));

}

void* Intersection(void* param)
{

	int m3[10000];
	int n3;

	bool isRepeat;
	n3 = 0;
	for (int i = 0; i < firstSize; ++i)
	{
		isRepeat = false;
		for (int j = 0; j < secondSize; ++j)     //Поиск среди второго "множества" 
			if (firstArray[i] == secondArray[j])      //если элементы равны
			{
				isRepeat = true;       //продолжаем итерацию цикла
				break;
			}


		if (isRepeat == true)
			m3[n3++] = (firstArray[i]);
	}

	fprintf(fout, "\n Совпадает ли множество С с пересечением А и В : %d\n", IsSame(m3,n3,CArray,CSize));

}
int IsSame(int f[], int fsize, int s[], int ssize) {
	if (fsize != ssize)
		return 0;
	for (int i = 0; i < fsize; i++) {
		if (f[i] < s[i]) return 0;
		else if (f[i] > s[i]) return 0;
	}
	return 1;
}
#pragma warning(disable : 4996)


int main(int args, char* argv[]) {                 // определяем функцию main
	if (firstArray == secondArray)
	{

	}
	if (args == 3) {
		fin = fopen(argv[1], "r");
		fout = fopen(argv[2], "w");



		fscanf(fin, "%d", &firstSize);

		for (int i = 0; i < firstSize; i++) {
			fscanf(fin, "%d", &firstArray[i]);
		}
		fscanf(fin, "%d", &secondSize);

		for (int i = 0; i < secondSize; i++) {
			fscanf(fin, "%d", &secondArray[i]);
		}
		fscanf(fin, "%d", &CSize);

		for (int i = 0; i < CSize; i++) {
			fscanf(fin, "%d", &CArray[i]);
		}


	}
	else if (args == 2) {
		fout = fopen(argv[1], "w");
		srand(42);
		firstSize = rand() / (RAND_MAX / 100);
		for (int i = 0; i < firstSize; i++) {
			firstArray[i] = rand() / (RAND_MAX / 100);
		}

		secondSize = rand() / (RAND_MAX / 100);
		for (int i = 0; i < secondSize; i++) {
			secondArray[i] = rand() / (RAND_MAX / 100);
		}

		CSize = rand() / (RAND_MAX / 100);
		for (int i = 0; i < CSize; i++) {
			CArray[i] = rand() / (RAND_MAX / 100);
		}

	}
	else if (args == 1) {
		fout = fopen("defaultOutput.txt", "w");
		srand(time(NULL));
		firstSize = rand() / (RAND_MAX / 100);
		for (int i = 0; i < firstSize; i++) {
			firstArray[i] = rand() / (RAND_MAX / 100);
		}

		secondSize = rand() / (RAND_MAX / 100);
		for (int i = 0; i < secondSize; i++) {
			secondArray[i] = rand() / (RAND_MAX / 100);
		}

		CSize = rand() / (RAND_MAX / 100);
		for (int i = 0; i < CSize; i++) {
			CArray[i] = rand() / (RAND_MAX / 100);
		}

	}


	pthread_t unionThread;
	pthread_t intersectionThread;
	pthread_t diffABThread;
	pthread_t diffBAThread;

	pthread_create(&unionThread, NULL, Union, NULL);
	pthread_create(&diffABThread, NULL, Diff_AB, NULL);
	pthread_create(&diffBAThread, NULL, Diff_BA, NULL);
	pthread_create(&intersectionThread, NULL, Intersection, NULL);

	pthread_join(unionThread, NULL);
	pthread_join(diffABThread, NULL);
	pthread_join(diffBAThread, NULL);
	pthread_join(intersectionThread, NULL);

	return 0;                   // выходим из функции
}