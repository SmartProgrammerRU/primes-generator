# primes-generator
Primes generator testing  project 

Версия 1.2

-  добавлена мультипоточность при генерации простых чисел до заданного предела.
   Исходный алгоритм поиска модифицирован: весь отрезок поиска разбит на куски; 
   сколько их должно быть для эффективного поиска? выбрано количество, 
   кратное текущему доступному количеству процессорных ядер на устройстве;
   таким образом, оперируя с меньшими по размеру отрезками, уменьшаем кол-во необходимой памяти,
   кроме того, выросло общее быстродействие

Версия 1.1

-  улучшена работа с памятью: изменен алгоритм работы с кешированными результатами,
   теперь сохраняется массив простых чисел (наибольшее число) а также история поисков;

   напр. число - 100
   [2, 3, 5, 7] - массив А
   число - 15
   [2, 3, 5, 7, 11, 13] - массив Б

   сохраняем наибольший массив
   при отображении списка простых чисел для числа меньше сохраненного (динамически формируем массив)
   как результат - уменьшение потребления памяти ~4 раза


Версия 1.0

В процессе выполнения тестового задания были сделаны следующие допущения:

-  поскольку приложение universal, т.е. работает на всех девайсах, 
   правильно (с точки зрения HIG) было бы сделать дизайн для ipad с 
   корневым UISplitViewController’om для того, чтобы показать пользователю 
   сразу экран генерации чисел, а также историю; для упрощения использован единый дизайн

-  в тестовых целях число, в пределах которого ищем простые числа, ограничено 10 000 000

-  в качестве индикатора загрузки использован обычный UIActivityViewIndicator