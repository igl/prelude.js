'use strict'

<-! suite 'array'

{
    empty, has, includes, clone, head, first, tail, last, initial, slice, splice,
    concat, remove, removeOne, flatten, each, map, find, findOne, shuffle,
    every, some, reverse, zip, zipWith, partition, unique, uniqueBy,
    difference, intersection, union, sortBy, countBy, groupBy, splitAt,
    index, indices, findIndex, findIndices
} = prelude.array

suite 'empty()' !->
    test 'returns correctly with valid inputs' !->
        strictEqual (empty []), true
        strictEqual (empty [1]), false

suite 'has()' !->
    test 'returns correctly with valid inputs' !->
        strictEqual ( has 0 [1 1] ), true
        strictEqual ( has 1 [1 2] ), true
        strictEqual ( has 2 [1 2] ), false
        strictEqual ( has 0 []    ), false

suite 'includes()' !->
    test 'returns correctly with valid inputs' !->
        strictEqual (includes 1 [1 2 3]), true
        strictEqual (includes 2 [1 2 3]), true
        strictEqual (includes 3 [1 2 3]), true
        strictEqual (includes 4 [1 2 3]), false
        strictEqual (includes 0 [1 2 3]), false
        strictEqual (includes '1' [1 2 3]), false

suite 'clone()' !->
    test 'returns the same as input' !->
        deepEqual do
            (clone [1 2 3])
            [1 2 3]

    test 'returns a copy' !->
        original = [1 2 3 4 5]
        copy     = clone original
        copy.2   = 'foo'

        strictEqual original.2, 3
        strictEqual copy.2, 'foo'

    test 'returns a deep copy' !->
        original = [1 2 [3 4] { a:'a' b:'b' }]
        expected = [1 2 [3 4] { a:'a' b:'b' }]

        copy     = clone original
        copy.2.0 = 'foo'
        copy.3.a = 'foo'

        deepEqual original, expected
        deepEqual copy, [1 2 ['foo' 4] { a:'foo' b:'b' }]

suite 'head()' !->
    test 'return first element' !->
        strictEqual (head [1 2 3]), 1

suite 'first()' !->
    test 'return first element' !->
        strictEqual (first [1 2 3]), 1

suite 'tail()' !->
    test 'return tail' !->
        deepEqual (tail [1 2 3]), [2 3]

suite 'last()' !->
    test 'return first element' !->
        strictEqual (last [1 2 3]), 3

suite 'initial()' !->
    test 'returns empty array when given an empty array' !->
        deepEqual (initial []), []

    test 'return all elements but the last' !->
        deepEqual (initial [1 2 3 4]), [1 2 3]

suite 'slice()' !->
    test 'slice array' !->
        deepEqual (slice 0, 3 [1 2 3 4]), [1 2 3]

    test 'slice with negative index' !->
        deepEqual (slice 0, -1 [1 2 3 4]), [1 2 3]

    test 'does not mutate input' !->
        input = [1 2 3 4]
        slice 0, 3, input
        deepEqual input, [1 2 3 4]

suite 'splice()' !->
    test 'splice array' !->
        deepEqual (splice 0, 2 [1 2 3 4]), [3 4]

    test 'splice nothing when splice-length less than 1' !->
        deepEqual (splice 0, 0 [1 2 3 4]), [1 2 3 4]
        deepEqual (splice 0, -1 [1 2 3 4]), [1 2 3 4]

    test 'does not mutate input' !->
        input = [1 2 3 4]
        deepEqual (splice 0, 1, input), [2 3 4]
        deepEqual input, [1 2 3 4]

suite 'concat()' !->
    test 'curries' !->
        isFunction concat [1 2]
        isArray ([3 4] |> concat [1 2])

    test 'concat 2' !->
        deepEqual (concat [1 2] [3 4]), [1 2 3 4]

    test 'concat more' !->
        deepEqual (concat [1 2] [3] [4 5] [6 7 8 9]), [1 2 3 4 5 6 7 8 9]

suite 'remove()' !->
    test 'curries' !->
        isFunction remove 1
        isArray ([3 4] |> remove 3)

    test 'remove all matches' !->
        deepEqual (remove 1, [1 1 1 2]), [2]

    test 'does not mutate input' !->
        input = [1 2 3]
        remove 2, input
        deepEqual input, [1 2 3]

suite 'removeOne()' !->
    test 'curries' !->
        isFunction removeOne [1 2]
        isArray ([3 4] |> removeOne [3])

    test 'removes the first match' !->
        deepEqual (removeOne 1, [1 2 1 2]), [2 1 2]

    test 'does not mutate input' !->
        input = [1 2 1 2]
        removeOne 2, input
        deepEqual input, [1 2 1 2]

suite 'flatten()' !->
    test 'flatten array' !->
        deepEqual do
            flatten [[1 2], [3 4]]
            [1 2 3 4]

suite 'each()' !->
    test 'curries' !->
        isFunction each (->)
        isArray each (->), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        each (-> count += 1), [1 2 3 4]
        strictEqual count, 4

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> each (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

suite 'map()' !->
    test 'curries' !->
        isFunction map (->)
        isArray map (->), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        map (-> ++count), [1 2 3]
        strictEqual count, 3

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> map (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

    test 'remap values' !->
        deepEqual do
            [0 1 2] |> map (-> it + 1)
            [1 2 3]

    test 'does not mutate input' !->
        input = [1 2 3]
        map (-> it * 2), input
        deepEqual input, [1 2 3]

suite 'find()' !->
    test 'curries' !->
        isFunction find (->)
        isArray    find (->), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        find (-> ++count), [1 2 3]
        strictEqual count, 3

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> find (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

    test 'finds values' !->
        deepEqual do
            find (-> typeof it isnt 'string'), [1 'foo' 2]
            [1 2]

    test 'does not mutate input' !->
        input = [1 2 3]
        find (-> it is 2), input
        deepEqual input, [1 2 3]

suite 'findOne()' !->
    test 'curries' !->
        isFunction findOne (->)
        isNumber   findOne (-> it is 2), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        findOne (!-> ++count), [1 2 3]
        strictEqual count, 3

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> findOne (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

    test 'finds and returns the first value' !->
        strictEqual do
            findOne (-> typeof it is 'string'), [1 'foo' 2 'bar']
            'foo'

    test 'returns undefined when nothing is found' !->
        strictEqual do
            findOne (-> typeof it is 'string'), [1 2 3 4]
            undefined

    test 'does not mutate input' !->
        input = [1 2 3]
        findOne (-> it is 2), input
        deepEqual input, [1 2 3]

suite 'shuffle()' !->
    test 'returns a shuffled array' !->
        i = 100
        while --i
            throws do
                -> deepEqual (shuffle [1 2 3 4 5 6 7 8 9]), [1 2 3 4 5 6 7 8 9]
                -> true

    test 'does not mutate input' !->
        input = [1 2 3 4 5]
        shuffle input
        deepEqual input, [1 2 3 4 5]

suite 'every()' !->
    test 'iterates over all items' !->
        count = 0
        strictEqual do
            [1 2 3] |> every -> ++count; true
            true
        strictEqual count, 3, 'did not iterate over full array'

    test 'iterates until miss' !->
        count = 0
        strictEqual do
            [1 2 3 4 5] |> every -> ++count; it < 3
            false
        strictEqual count, 3, "iterator was called too often (#count)"

suite 'some()' !->
    test 'iterates over all items' !->
        count = 0
        deepEqual do
            [1 2 3] |> some -> count++; false
            false
        strictEqual count, 3, 'did not iterate over full array'

    test 'iterates until found' !->
        count = 0
        strictEqual do
            [1 2 3 4 5] |> some -> ++count; it > 2
            true
        strictEqual count, 3, "iterator was called too often (#count)"

suite 'reverse()' !->
    test 'reverses array' !->
        deepEqual do
            reverse [1 2 3]
            [3 2 1]

suite 'zip()' !->
    test 'zips array' ->
        deepEqual do
            zip [1 2 3] [4 5 6]
            [[1 4], [2 5], [3 6]]

    test 'curries' ->
        isFunction zip [1 2 3]
        isArray ([4 5 6] |> zip [1 2 3] )

    test 'zip with uneven array length (1)' ->
        deepEqual do
            zip [1 2 9] [3 4]
            [[1 3], [2 4]]

    test 'zip with uneven array length (2)' ->
        deepEqual do
            zip [1 2] [3 4 9]
            [[1 3], [2 4]]

suite 'zipWith()' !->
    test 'curries' !->
        isFunction zipWith (->)
        isFunction zipWith (->), [1 2 3]
        isArray    zipWith (->), [1 2 3] [1 2 3]

    test 'zips array' ->
        deepEqual do
            zipWith (-> &0 + &1), [1 2] [3 4]
            [4 6]

    test 'zips multible arrays' ->
        deepEqual do
            zipWith (-> &0 + &1 + &2), [1 2] [2 1] [10 20]
            [13 23]

    test 'zip with uneven array length (1)' ->
        deepEqual do
            zipWith (-> &0 + &1), [1 2 9] [3 4]
            [4 6]

    test 'zip with uneven array length (2)' ->
        deepEqual do
            zipWith (-> &0 + &1), [1 2] [3 4 9]
            [4 6]

suite 'partition()' !->
    test 'curries' !->
        isFunction partition (->)
        isArray    partition (->), [1 2 3]

    test 'partitions array' !->
        deepEqual do
            partition (-> it is 2), [1 2 3 4]
            [[2], [1 3 4]]

suite 'unique()' !->
    test 'return unique items' !->
        deepEqual do
            unique [1 1 2 3 3 4 5]
            [1 2 3 4 5]

suite 'uniqueBy()' !->
    test 'curries' !->
        deepEqual do
            <[fo fo foo fooo fooo]> |> uniqueBy (.length)
            <[fo foo fooo]>

    test 'return unique items' !->
        deepEqual do
            uniqueBy (.length), <[fo fo foo fooo fooo]>
            <[fo foo fooo]>

suite 'difference()' !->
    test 'return difference' !->
        deepEqual do
            difference [1 2 3], [1 4 5]
            [2 3]

suite 'intersection()' !->
    test 'return intersecting' !->
        deepEqual do
            intersection [1 2 3], [1 2 5]
            [1 2]

suite 'union()' !->
    test 'curries' !->
        deepEqual do
            [1 3 4] |> union [1 2]
            [1 2 3 4]

    test 'return unions' !->
        deepEqual do
            union [1 2], [1 3 4], [1 5]
            [1 2 3 4 5]

suite 'sortBy()' !->
    test 'curries' !->
        deepEqual do
            isFunction sortBy (% 2)

    test 'sort with func' !->
        deepEqual do
            sortBy (% 2), [6 5 1 2 3 4]
            [6 2 4 5 1 3]

suite 'countBy()' !->
    test 'curries' !->
        deepEqual do
            isFunction countBy (.length)

    test 'count by' !->
        deepEqual do
            countBy (.length), <[ one two three ]>
            { 3:2, 5:1 }

suite 'groupBy()' !->
    test 'curries' !->
        isFunction groupBy (.length)

        deepEqual do
            <[ one two three ]> |> groupBy (.length)
            { 3:['one', 'two'], 5:['three'] }

    test 'group by' !->
        deepEqual do
            groupBy (.length), <[ one two three ]>
            { 3:['one', 'two'], 5:['three'] }

suite 'splitAt()' !->
    test 'curries' !->
        isFunction (splitAt 2)

        deepEqual do
            [ 1 to 5 ] |> splitAt 2
            [ [1, 2], [3, 4, 5] ]

    test 'split array at position 2' !->
        deepEqual do
            splitAt 2, [ 1 to 5 ]
            [ [1, 2], [3, 4, 5] ]

    test 'split negative index at 0' !->
        deepEqual do
            splitAt -1, [ 1 to 5 ]
            [ [], [1, 2, 3, 4, 5] ]

suite 'index()' !->
    test 'curries' !->
        isFunction (index 2)

        strictEqual do
            [1 2 3] |> index 2
            1

    test 'returns the index of element in array' !->
        strictEqual do
            [1 2 3] |> index 2
            1

    test 'returns undefined of element is not found in array' !->
        strictEqual do
            [1 2 3] |> index 5
            void

suite 'indices()' !->
    test 'curries' !->
        isFunction (indices 2)

        deepEqual do
            [1 2 3] |> indices 2
            [1]

    test 'returns single index of element in array' !->
        deepEqual do
            [1 2 3] |> indices 2
            [1]

    test 'returns multible indices of element in array' !->
        deepEqual do
            [1 2 3 4 2 5 6] |> indices 2
            [1 4]


    test 'returns empty array if nothing is found in array' !->
        deepEqual do
            [1 2 3 4] |> indices 5
            []

suite 'findIndex()' !->
    test 'curries' !->
        isFunction findIndex (is 2)

    test 'returns single index of element in array' !->
        strictEqual do
            [1 2 3] |> findIndex (is 2)
            1

suite 'findIndices()' !->
    test 'curries' !->
        isFunction findIndices (is 2)

    test 'returns single index of element in array' !->
        deepEqual do
            [1 2 3] |> findIndices (is 2)
            [1]

    test 'returns multible indices of element in array' !->
        deepEqual do
            [1 2 3 2 1] |> findIndices (is 2)
            [1 3]
