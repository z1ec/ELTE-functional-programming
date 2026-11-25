# Теория к квизу на endterm

На экзамене есть 10 теоретических вопросов по 1 баллу. Это 10% итоговой оценки, и по квизам вместе нужно набрать минимум 50%. Ниже вопросы по темам syllabus. Сначала ответь сам, потом открывай ответ.

## 1. Вычисление: редукция, redex, нормальная форма

**1.1. Что такое редекс (redex)?**
<details><summary>Ответ</summary>
Часть выражения, которую можно упростить одним шагом (reducible expression). Например, применение функции к аргументу <code>square 3</code> или <code>2 + 3</code>.
</details>

**1.2. Что такое нормальная форма?**
<details><summary>Ответ</summary>
Выражение, в котором не осталось ни одного редекса, то есть дальше упростить нельзя. Например, <code>25</code> или <code>[1,2,3]</code>.
</details>

**1.3. Распиши шаги для `square (1 + 2)`, где `square x = x * x`, при ленивом и при энергичном вычислении.**
<details><summary>Ответ</summary>
Энергичное (eager, innermost): сначала аргумент.<br>
<code>square (1+2) → square 3 → 3*3 → 9</code><br>
Ленивое (lazy, outermost): сначала функция, аргумент считается, только когда нужен. Благодаря sharing он считается один раз.<br>
<code>square (1+2) → (1+2)*(1+2) → 3*3 → 9</code>, где <code>(1+2)</code> общий и вычисляется один раз.
</details>

**1.4. Чем ленивое (lazy) вычисление отличается от энергичного (eager / strict)?**
<details><summary>Ответ</summary>
Eager считает аргументы <b>до</b> вызова функции (innermost reduction). Lazy считает выражение, только когда его значение действительно нужно (outermost reduction + sharing). Haskell ленивый.
</details>

**1.5. Что вернёт `fst (5, undefined)` в Haskell и почему?**
<details><summary>Ответ</summary>
<code>5</code>. Второй элемент пары не нужен, поэтому из-за ленивости он не вычисляется и ошибки нет. При энергичном вычислении была бы ошибка.
</details>

**1.6. Почему `take 3 [1..]` работает, хотя `[1..]` бесконечный?**
<details><summary>Ответ</summary>
Из-за ленивости. Элементы списка создаются по одному, только когда <code>take</code> их запрашивает. После трёх элементов вычисление останавливается.
</details>

**1.7. Что произойдёт с `length [1..]`?**
<details><summary>Ответ</summary>
Программа зависнет. Чтобы узнать длину, нужен весь список, а он бесконечный.
</details>

**1.8. Что такое чистая функция (pure function) и referential transparency?**
<details><summary>Ответ</summary>
Чистая функция при одинаковых аргументах всегда даёт одинаковый результат и не имеет побочных эффектов. Referential transparency означает, что выражение можно заменить его значением, и смысл программы не изменится.
</details>

## 2. Функции и типы

**2.1. Что такое каррирование (currying)? Какой тип у `add x y = x + y` для Int?**
<details><summary>Ответ</summary>
<code>add :: Int -> Int -> Int</code>, то есть <code>Int -> (Int -> Int)</code>. Функция берёт аргументы по одному: <code>add 2</code> — это новая функция, которая прибавляет 2.
</details>

**2.2. Что такое частичное применение? Пример.**
<details><summary>Ответ</summary>
Вызов функции с частью аргументов, результат которого — функция. Примеры: <code>map (add 1) [1,2]</code>, <code>(*2)</code>, <code>filter (> 3)</code>.
</details>

**2.3. Что такое функция высшего порядка?**
<details><summary>Ответ</summary>
Функция, которая принимает функцию как аргумент или возвращает функцию. Примеры: <code>map</code>, <code>filter</code>, <code>foldr</code>, <code>iterate</code>, <code>(.)</code>.
</details>

**2.4. Какие типы у `map`, `filter`, `foldr`?**
<details><summary>Ответ</summary>
<code>map :: (a -> b) -> [a] -> [b]</code><br>
<code>filter :: (a -> Bool) -> [a] -> [a]</code><br>
<code>foldr :: (a -> b -> b) -> b -> [a] -> b</code> (для списков)
</details>

**2.5. Что такое полиморфный тип? Что значит `a` в `length :: [a] -> Int`?**
<details><summary>Ответ</summary>
<code>a</code> — переменная типа. Функция работает для списков с элементами любого типа.
</details>

**2.6. Что значит `Ord a =>` в `maximum :: Ord a => [a] -> a`?**
<details><summary>Ответ</summary>
Это ограничение класса (class constraint). Тип <code>a</code> может быть любым, но он должен иметь instance <code>Ord</code>, то есть его значения можно сравнивать.
</details>

**2.7. Что такое лямбда-выражение?**
<details><summary>Ответ</summary>
Функция без имени: <code>\x -> x + 1</code>, <code>\x y -> x * y</code>.
</details>

**2.8. Что делает `(f . g) x`?**
<details><summary>Ответ</summary>
Это композиция: <code>f (g x)</code>. Сначала применяется g, потом f.
</details>

**2.9. Чем `foldr` отличается от `foldl`?**
<details><summary>Ответ</summary>
<code>foldr f z [a,b,c] = f a (f b (f c z))</code> сворачивает справа.<br>
<code>foldl f z [a,b,c] = f (f (f z a) b) c</code> сворачивает слева.<br>
<code>foldr</code> может работать с бесконечными списками, если <code>f</code> ленивая по второму аргументу. <code>foldl</code> на бесконечном списке зависнет.
</details>

**2.10. Что такое guards и чем они отличаются от pattern matching?**
<details><summary>Ответ</summary>
Pattern matching выбирает уравнение по <b>форме</b> аргумента: <code>[]</code>, <code>(x:xs)</code>, <code>Leaf</code>. Guards выбирают по <b>условию</b>: <code>| x > 0 = ...</code>, <code>| otherwise = ...</code>.
</details>

## 3. Структуры данных

**3.1. Чем список отличается от кортежа?**
<details><summary>Ответ</summary>
В списке все элементы одного типа, а длина любая (<code>[Int]</code>). В кортеже фиксированное число элементов, и они могут быть разных типов (<code>(Int, String)</code>).
</details>

**3.2. Что такое record? Что получаешь автоматически при объявлении полей?**
<details><summary>Ответ</summary>
Это data-тип с именованными полями: <code>data P = P {name :: String, age :: Int}</code>. Для каждого поля автоматически создаётся функция-селектор, например <code>name :: P -> String</code>. Ещё работает update-синтаксис <code>p { age = 5 }</code>.
</details>

**3.3. Что такое алгебраический тип данных? Почему «алгебраический»?**
<details><summary>Ответ</summary>
Это тип, собранный из конструкторов. «Сумма» означает варианты через <code>|</code> (Circle | Rect). «Произведение» означает несколько полей в конструкторе (Rect Double Double). Пример: <code>data Shape = Circle Double | Rect Double Double</code>.
</details>

**3.4. Что такое рекурсивный тип? Пример.**
<details><summary>Ответ</summary>
Тип, который ссылается сам на себя: <code>data Tree a = Leaf | Node a (Tree a) (Tree a)</code>. Список тоже рекурсивный: <code>x : xs</code>.
</details>

**3.5. Что такое `Maybe` и зачем он нужен?**
<details><summary>Ответ</summary>
<code>data Maybe a = Nothing | Just a</code>. Это результат, которого может не быть, без <code>error</code>. Пример: безопасный head или деление на 0.
</details>

**3.6. Какие бывают обходы двоичного дерева?**
<details><summary>Ответ</summary>
Preorder: корень, левое, правое. Inorder: левое, корень, правое. Postorder: левое, правое, корень. Inorder дерева поиска выдаёт значения по возрастанию.
</details>

**3.7. Что такое дерево поиска (BST)?**
<details><summary>Ответ</summary>
Двоичное дерево, в котором у каждого узла все значения слева меньше, а все справа больше. Поиск идёт только в одну сторону, поэтому в сбалансированном дереве он занимает O(log n).
</details>

## 4. Классы и instance

**4.1. Что такое класс типов (type class)?**
<details><summary>Ответ</summary>
Набор функций (методов), которые тип обязуется реализовать. Например, <code>class Eq a where (==) :: a -> a -> Bool</code>. Это похоже на интерфейс.
</details>

**4.2. Что такое instance?**
<details><summary>Ответ</summary>
Реализация методов класса для конкретного типа: <code>instance Show Color where show Red = "red"</code>.
</details>

**4.3. Чем `deriving (Show, Eq)` отличается от своего `instance`?**
<details><summary>Ответ</summary>
<code>deriving</code> генерирует стандартную реализацию: печать как в коде, равенство всех полей. Свой <code>instance</code> нужен, когда требуется другой формат или другое правило равенства. Писать оба для одного типа нельзя.
</details>

**4.4. Какой минимум нужно определить для Eq? А для Ord?**
<details><summary>Ответ</summary>
Для Eq нужно <code>==</code> (или <code>/=</code>). Для Ord нужно <code>compare</code> (или <code><=</code>), и у типа уже должен быть Eq.
</details>

**4.5. Назови стандартные классы и их методы.**
<details><summary>Ответ</summary>
Eq (<code>==</code>, <code>/=</code>), Ord (<code>compare</code>, <code><</code>, <code>max</code>), Show (<code>show</code>), Num (<code>+</code>, <code>*</code>, <code>abs</code>, <code>fromInteger</code>), Enum (<code>succ</code>, <code>[a..b]</code>), Bounded (<code>minBound</code>, <code>maxBound</code>), Integral (<code>div</code>, <code>mod</code>), Fractional (<code>/</code>).
</details>

**4.6. Почему `5 / 2` работает, а `length xs / 2` даёт ошибку типа?**
<details><summary>Ответ</summary>
<code>/</code> требует класс Fractional (Double), а <code>length</code> возвращает Int. Нужно перевести: <code>fromIntegral (length xs) / 2</code>.
</details>

## 5. Списки и генераторы

**5.1. Что вернёт `[(x,y) | x <- [1,2], y <- "ab"]`?**
<details><summary>Ответ</summary>
<code>[(1,'a'),(1,'b'),(2,'a'),(2,'b')]</code>, то есть все пары, как вложенный цикл.
</details>

**5.2. Что вернёт `[(x,y) | x <- [1,2] | y <- "ab"]` (ParallelListComp)?**
<details><summary>Ответ</summary>
<code>[(1,'a'),(2,'b')]</code>. Генераторы идут параллельно, как <code>zip</code>.
</details>

**5.3. Что вернёт `takeWhile even [2,4,5,6]` и `dropWhile even [2,4,5,6]`?**
<details><summary>Ответ</summary>
<code>[2,4]</code> и <code>[5,6]</code>.
</details>

**5.4. Что вернёт `iterate (*2) 1`?**
<details><summary>Ответ</summary>
Бесконечный список <code>[1,2,4,8,16,...]</code>.
</details>

**5.5. Что вернёт `zipWith (+) [1,2,3] [10,20]`?**
<details><summary>Ответ</summary>
<code>[11,22]</code>. Длина берётся по короткому списку.
</details>

**5.6. Что такое «двойная рекурсия» на примере Фибоначчи? Почему она медленная?**
<details><summary>Ответ</summary>
<code>fib n = fib (n-1) + fib (n-2)</code>. Каждый вызов порождает два новых, и одни и те же значения считаются много раз, поэтому время экспоненциальное. Быстрый вариант — ленивый список <code>fibs = 0 : 1 : zipWith (+) fibs (tail fibs)</code>.
</details>

**5.7. Какая сложность у quicksort, mergesort и insertion sort?**
<details><summary>Ответ</summary>
Insertion sort: O(n²). Quicksort: в среднем O(n log n), в худшем случае O(n²), например на уже отсортированном списке с первым элементом в качестве опорного. Merge sort: всегда O(n log n).
</details>
