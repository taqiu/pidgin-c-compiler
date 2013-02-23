/*
 * correct example 
 *
 */

void swap(int *a, int *b);
void sort(int arr[], int beg, int end);

int main(int argc, int * argv[10]) {
	int a[19];
	sort(a, 0, 18);
}

void swap(int *a, int *b) {
	int t;
	t = *a;
	*a = *b;
	*b = t;
}
void sort(int arr[], int beg, int end) {
	if (end > beg + 1) {
		int piv, l, r;
		piv = arr[beg];
		l = beg + 1;
		r = end;
		while (l < r) {
			if (arr[l] <= piv) {
				l = l + 1;
			} else {
				swap(&arr[l], &arr[r-1]);
			}
		}
		swap(&arr[l-1], &arr[beg]);
		sort(arr, beg, l);
		sort(arr, r, end);
	}
}
