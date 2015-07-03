# primes-generator
Primes generator testing  project 

В процессе выполнения тестового задания были сделаны следующие допущения:

-  поскольку приложение universal, т.е. работает на всех девайсах, 
   правильно (с точки зрения HIG) было бы сделать дизайн для ipad с 
   корневым UISplitViewController’om для того, чтобы показать пользователю 
   сразу экран генерации чисел, а также историю; для упрощения использован единый дизайн

-  в тестовых целях число, в пределах которого ищем простые числа, ограничено 10 000 000

-  в качестве индикатора загрузки использован обычный UIActivityViewIndicator

-  ограничен размер файла, куда сохраняем данные; кроме того, для простоты работы 
   с памятью допускаем, что, если размер файла превышает 50Мб - чистим старые данные

-  опять же с целью упрощения отображения элементов, экран истории генераций 
   выглядит след образом: исходя из задания, отображать поиск пользователя 
   необходимо в коллекции (напр. UITableView), однако сама идея размещения 
   больших данных в таблице не хороша, в задании представлен вариант, когда 
   в ячейку вставлен textview; 
   не самый лучший вариант для работы с памятью, т.к. забирает сразу и всю требуемую память

