# gpdb-roaringbitmap
RoaringBitmap extension for greenplum-db


# Introduction
Roaring bitmaps are compressed bitmaps which tend to outperform conventional compressed bitmaps such as WAH, EWAH or Concise. In some instances, roaring bitmaps can be hundreds of times faster and they often offer significantly better compression. They can even be faster than uncompressed bitmaps. More information https://github.com/RoaringBitmap/CRoaring.   

Roaringbitmap是一种高效的Bitmap压缩算法，目前已被广泛应用在各种语言和各种大数据平台上。  
本插件将Roaringbitmap功能集成到Greenplum数据库中，将Roaringbitmap作为一种数据类型提供原生的数据库函数、操作符、聚合等功能支持。  
Bitmap位计算非常适合大数据基数计算，常用于去重、标签筛选、时间序列等计算中。  

# Build

```
su - gpadmin
make
make install
```
Make sure all nodes are copied the extension files.  
确保插件文件同步到所有节点所对应的目录下。

```
psql -c "create extension roaringbitmap;"
```

# Usage

## Create table 创建表
```
CREATE TABLE t1 (id integer, bitmap roaringbitmap);
```

## Build bitmap 生成一个Bitmap
```
INSERT INTO t1 SELECT 1,RB_BUILD(ARRAY[1,2,3,4,5,6,7,8,9,200]);

INSERT INTO t1 SELECT 2,RB_BUILD_AGG(e) FROM GENERATE_SERIES(1,100) e;
```

## Bitmap Calculation (OR, AND, XOR, ANDNOT) Bitmap计算
```
SELECT RB_OR(a.bitmap,b.bitmap) FROM (SELECT bitmap FROM t1 WHERE id = 1) AS a,(SELECT bitmap FROM t1 WHERE id = 2) AS b;
```

## Bitmap Aggregate (OR, AND, XOR, BUILD) Bitmap聚合
```
SELECT RB_OR_AGG(bitmap) FROM t1;
SELECT RB_AND_AGG(bitmap) FROM t1;
SELECT RB_XOR_AGG(bitmap) FROM t1;
SELECT RB_BUILD_AGG(e) FROM GENERATE_SERIES(1,100) e;
```

## Cardinality 统计基数
```
SELECT RB_CARDINALITY(bitmap) FROM t1;
```

## Bitmap to SETOF integer 转换为Offset List
```
SELECT RB_ITERATE(bitmap) FROM t1 WHERE id = 1;
SELECT RB_ITERATE_DECREMENT(bitmap) FROM t1 WHERE id = 1;
```

## Function List 函数一览
<table>
    <thead>
           <th>Function</th>
           <th>Input</th>
           <th>Output</th>
           <th>Desc</th>
           <th>Example</th>
    </thead>
    <tr>
        <td>rb_build</td>
        <td>integer[]</td>
        <td>roaringbitmap</td>
        <td>
            Build a roaringbitmap from integer array.<br>通过数组创建一个Bitmap。
        </td>
        <td>rb_build('{1,2,3,4,5}')</td>
    </tr>
    <tr>
        <td>rb_to_array</td>
        <td>roaringbitmap</td>
        <td>integer[]</td>
        <td>
            Bitmap to integer array.<br>Bitmap转数组。
        </td>
        <td>rb_to_array(rb_build('{1,2,3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_and</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>roaringbitmap</td>
        <td>Two roaringbitmap and calculation.<br>And计算。</td>
        <td>rb_and(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_or</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>roaringbitmap</td>
        <td>Two roaringbitmap or calculation.<br>Or计算。</td>
        <td>rb_or(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_xor</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>roaringbitmap</td>
        <td>Two roaringbitmap xor calculation.<br>Xor计算。</td>
        <td>rb_xor(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_andnot</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>roaringbitmap</td>
        <td>Two roaringbitmap andnot calculation.<br>AndNot计算</td>
        <td>rb_andnot(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_cardinality</td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>Retrun roaringbitmap cardinality.<br>统计基数</td>
        <td>rb_cardinality(rb_build('{1,2,3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_and_cardinality</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>integer</td>
        <td>Two roaringbitmap and calculation, return cardinality.<br>And计算并返回基数。</td>
        <td>rb_and_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_or_cardinality</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>integer</td>
        <td>Two roaringbitmap or calculation, return cardinality.<br>Or计算并返回基数。</td>
        <td>rb_or_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_xor_cardinality</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>integer</td>
        <td>Two roaringbitmap xor calculation, return cardinality.<br>Xor计算并返回基数。</td>
        <td>rb_xor_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_andnot_cardinality</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>integer</td>
        <td>Two roaringbitmap andnot calculation, return cardinality.<br>AndNot计算并返回基数。</td>
        <td>rb_andnot_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_is_empty</td>
        <td>roraingbitmap</td>
        <td>boolean</td>
        <td>Check if roaringbitmap is empty.<br>判断是否为空的Bitmap。</td>
        <td>rb_is_empty(rb_build('{1,2,3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_equals</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>boolean</td>
        <td>Check two roaringbitmap are equal.<br>判断两个Bitmap是否相等。</td>
        <td>rb_equals(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
        <tr>
        <td>rb_not_equals</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>boolean</td>
        <td>Check two roaringbitmap are not equal.<br>判断两个Bitmap是否不同。</td>
        <td>rb_not_equals(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_intersect</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>boolean</td>
        <td>Check two roaringbitmap are intersect.<br>判断两个Bitmap是否相交。</td>
        <td>rb_intersect(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_contains</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>boolean</td>
        <td>Check roaringbitmap conatins another one.<br>判断Bitmap是否包含另外一个。</td>
        <td>rb_contains(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_contains</td>
        <td>roraingbitmap<br>integer</td>
        <td>boolean</td>
        <td>Check roaringbitmap conatins a specific offset.<br>判断Bitmap是否包含特定的Offset。</td>
        <td>rb_contains(rb_build('{1,2,3}'),1)</td>
    </tr>
    <tr>
        <td>rb_contains</td>
        <td>roraingbitmap<br>integer<br>integer</td>
        <td>boolean</td>
        <td>Check roaringbitmap conatins a specific offsets range.<br>判断Bitmap是否包含特定的Offset段。</td>
        <td>rb_contains(rb_build('{1,2,3}'),1,3)</td>
    </tr>
    <tr>
        <td>rb_becontained</td>
        <td>roraingbitmap<br>roaringbitmap</td>
        <td>boolean</td>
        <td>Check roaringbitmap is contained by another one.<br>判断Bitmap是否被另外一个包含。</td>
        <td>rb_becontained(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_becontained</td>
        <td>integer<br>roaringbitmap</td>
        <td>boolean</td>
        <td>Check a specific offset is contained by Bitmap.<br>判断特定的Offset是否被Bitmap包含。</td>
        <td>rb_becontained(1,rb_build('{3,4,5}'))</td>
    </tr>
    <tr>
        <td>rb_add</td>
        <td>roraingbitmap<br>integer</td>
        <td>roraingbitmap</td>
        <td>Add a specific offset to roaringbitmap.<br>添加特定的Offset到Bitmap。</td>
        <td>rb_add(rb_build('{1,2,3}'),3)</td>
    </tr>
    <tr>
        <td>rb_add</td>
        <td>roraingbitmap<br>integer<br>integer</td>
        <td>roraingbitmap</td>
        <td>Add a specific offsets range to roaringbitmap.<br>添加特定的Offset段到Bitmap。</td>
        <td>rb_add(rb_build('{1,2,3}'),3,4)</td>
    </tr>
    <tr>
        <td>rb_remove</td>
        <td>roraingbitmap<br>integer</td>
        <td>roraingbitmap</td>
        <td>Remove a specific offset from roaringbitmap.<br>从Bitmap移除特定的Offset。</td>
        <td>rb_remove(rb_build('{1,2,3}'),3)</td>
    </tr>
    <tr>
        <td>rb_remove</td>
        <td>roraingbitmap<br>integer<br>integer</td>
        <td>roraingbitmap</td>
        <td>Remove a specific offsets rang from roaringbitmap.<br>从Bitmap移除特定的Offset段。</td>
        <td>rb_remove(rb_build('{1,2,3}'),2,3)</td>
    </tr>
     <tr>
        <td>rb_flip</td>
        <td>roraingbitmap<br>integer</td>
        <td>roraingbitmap</td>
        <td>Flip a specific offset from roaringbitmap.<br>翻转Bitmap中特定的Offset。</td>
        <td>rb_flip(rb_build('{1,2,3}'),3)</td>
    </tr>
    <tr>
        <td>rb_flip</td>
        <td>roraingbitmap<br>integer<br>integer</td>
        <td>roraingbitmap</td>
        <td>Flip a specific offsets range from roaringbitmap.<br>翻转Bitmap中特定的Offset段。</td>
        <td>rb_flip(rb_build('{1,2,3}'),2,3)</td>
    </tr>
    <tr>
        <td>rb_minimum</td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>Return the smallest offset in roaringbitmap. Return -1 if the bitmap is empty.<br>返回Bitmap中最小的Offset，如果Bitmap为空则返回-1。
        <td>rb_minimum(rb_build('{1,2,3}'))</td>
    </tr>
    <tr>
        <td>rb_maximum</td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>Return the greatest offset in roaringbitmap. Return 0 if the bitmap is empty.<br>返回Bitmap中最大的Offset，如果Bitmap为空则返回0。</td>
        <td>rb_maximum(rb_build('{1,2,3}'))</td>
    </tr>
    <tr>
        <td>rb_rank</td>
        <td>roraingbitmap<br>integer</td>
        <td>integer</td>
        <td>Return the number of offsets that are smaller or equal to a specific offset.<br>返回Bitmap中小于等于指定Offset的基数。</td>
        <td>rb_rank(rb_build('{1,2,3}'),3)</td>
    </tr>
    <tr>
        <td>rb_jaccard_index</td>
        <td>roraingbitmap<br>roraingbitmap</td>
        <td>float8</td>
        <td>Computes the Jaccard index between two bitmaps. <br>计算两个Bitmap之间的jaccard相似系数。</td>
        <td>rb_jaccard_index(rb_build('{1,2,3}'),rb_build('{1,2,3，4}'))</td>
    </tr>
    <tr>
        <td>rb_iterate</td>
        <td>roraingbitmap</td>
        <td>setof integer</td>
        <td>Return offsets List in increasing orders.<br>返回Offset List （从小到大）。</td>
        <td>rb_iterate(rb_build('{1,2,3}'))</td>
    </tr>
     <tr>
        <td>rb_iterate_decrement</td>
        <td>roraingbitmap</td>
        <td>setof integer</td>
        <td>Return offsets List in decreasing orders.<br>返回Offset List（从大到小）。</td>
        <td>rb_iterate_decrement(rb_build('{1,2,3}'))</td>
    </tr>
</table>

## Operator List 操作符一览
<table>
    <thead>
           <th>Operator</th>
           <th>Left</th>
           <th>Right</th>
           <th>Output</th>
           <th>Desc</th>
           <th>Example</th>
    </thead>
    <tr>
        <td>&</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Two roaringbitmap and calculation.<br>两个Bitmap And 操作。</td>
        <td>rb_build('{1,2,3}') & rb_build('{1,2,3}')</td>
    </tr>
    <tr>
        <td>|</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Two roaringbitmap or calculation.<br>两个Bitmap Or 操作。</td>
        <td>rb_build('{1,2,3}') | rb_build('{1,2,3}')</td>
    </tr>
    <tr>
        <td>#</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Two roaringbitmap xor calculation.<br>两个Bitmap Xor 操作。</td>
        <td>rb_build('{1,2,3}') # rb_build('{1,2,3}')</td>
    </tr>
    <tr>
        <td>~</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Two roaringbitmap andnot calculation.<br>两个Bitmap Andnot 操作。</td>
        <td>rb_build('{1,2,3}') ~ rb_build('{1,2,3}')</td>
    </tr>
    <tr>
        <td>+</td>
        <td>roraingbitmap</td>
        <td>intger</td>
        <td>roraingbitmap</td>
        <td>Add a specific offset from roaringbitmap.<br>向Bitmap中添加特定的Offset。</td>
        <td>rb_build('{1,2,3}') + 4</td>
    </tr>
    <tr>
        <td>+</td>
        <td>intger</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Add a specific offset from roaringbitmap.<br>向Bitmap添加特定的Offset。</td>
        <td>4 + rb_build('{1,2,3}') </td>
    </tr>
    <tr>
        <td>-</td>
        <td>roraingbitmap</td>
        <td>intger</td>
        <td>roraingbitmap</td>
        <td>Remove a specific offset from roaringbitmap.<br>从Bitmap移除特定的Offset。</td>
        <td>rb_build('{1,2,3}') - 1</td>
    </tr>
    <tr>
        <td>=</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>boolean</td>
        <td>Check two roaringbitmap are equal.<br>判断两个Bitmap是否相等。</td>
        <td>rb_build('{1,2,3}') = rb_build('{3,2,1}') </td>
    </tr>
    <tr>
        <td>&&</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>boolean</td>
        <td>Check two roaringbitmaps are intersected.<br>判断两个Bitmap是否相交。</td>
        <td>rb_build('{1,2,3}') && rb_build('{3,2,1}') </td>
    </tr>
    <tr>
        <td>@></td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>boolean</td>
        <td>Check roaringbitmap conatins another one.<br>判断Bitmap是否包含另外一个</td>
        <td>rb_build('{1,2,3}') @> rb_build('{3,1}') </td>
    </tr>
    <tr>
        <td>@></td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>boolean</td>
        <td>Check roaringbitmap conatins a specific offset.<br>判断Bitmap是否包含特定的Offset。</td>
        <td>rb_build('{1,2,3}') @> 1 </td>
    </tr>
    <tr>
        <td><@</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>boolean</td>
        <td>Check roaringbitmap is contained by another one.<br>判断Bitmap是否被另外一个包含。</td>
        <td>rb_build('{1,3}') <@ rb_build('{3,2,1}') </td>
    </tr>
    <tr>
        <td><@</td>
        <td>integer</td>
        <td>roraingbitmap</td>
        <td>boolean</td>
        <td>Check a specific offset is contained by Bitmap.<br>判断特定的Offset是否被Bitmap包含。</td>
        <td>1 <@ rb_build('{1,2,3}')  </td>
    </tr>
</table>

## Aggregation List 聚合函数一览
<table>
    <thead>
           <th>Aggregation</th>
           <th>Input</th>
           <th>Output</th>
           <th>Desc</th>
           <th>Example</th>
    </thead>
    <tr>
        <td>rb_build_agg</td>
        <td>integer</td>
        <td>roraingbitmap</td>
        <td>Build a roaringbitmap from a integer set.<br>将Offset聚合成bitmap。</td>
        <td>rb_build_agg(1)</td>
    </tr> 
    <tr>
        <td>rb_or_agg</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Or Aggregate calculations from a roraingbitmap set.<br>Or 聚合计算。</td>
        <td>rb_or_agg(rb_build('{1,2,3}'))</td>
    </tr>
    <tr>
        <td>rb_and_agg</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>And Aggregate calculations from a roraingbitmap set.<br>And 聚合计算。</td>
        <td>rb_and_agg(rb_build('{1,2,3}'))</td>
    </tr>
    <tr>
        <td>rb_xor_agg</td>
        <td>roraingbitmap</td>
        <td>roraingbitmap</td>
        <td>Xor Aggregate calculations from a roraingbitmap set.<br>Xor 聚合计算。</td>
        <td>rb_xor_agg(rb_build('{1,2,3}'))</td>
    </tr>    
    <tr>
        <td>rb_or_cardinality_agg</td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>Or Aggregate calculations from a roraingbitmap set, return cardinality.<br>Or 聚合计算并返回其基数。</td>
        <td>rb_or_cardinality_agg(rb_build('{1,2,3}'))</td>
    </tr>   
    <tr>
        <td>rb_and_cardinality_agg</td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>And Aggregate calculations from a roraingbitmap set, return cardinality.<br>And 聚合计算并返回其基数。</td>
        <td>rb_and_cardinality_agg(rb_build('{1,2,3}'))</td>
    </tr>  
    <tr>
        <td>rb_xor_cardinality_agg</td>
        <td>roraingbitmap</td>
        <td>integer</td>
        <td>Xor Aggregate calculations from a roraingbitmap set, return cardinality.<br>Xor 聚合计算并返回其基数。</td>
        <td>rb_xor_cardinality_agg(rb_build('{1,2,3}'))</td>
    </tr>
</table>
