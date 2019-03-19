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
SELECT RB_OR(a.bitmap,b.bitmap) FORM (SELECT bitmap FROM t1 WHERE id = 1) AS a,(SELECT bitmap FROM t1 WHERE id = 2) AS b;
```

## Bitmap Aggregate (OR, AND, XOR, BUILD) Bitmap聚合
```
SELECT RB_OR_AGG(bitmap) FROM t1;
SELECT RB_AND_AGG(bitmap) FORM t1;
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
        <td><code>rb_build</code></td>
        <td><code>integer[]</code></td>
        <td><code>roaringbitmap</code></td>
        <td>
            Build a roaringbitmap from integer array.<BR>通过数组创建一个Bitmap。
        </td>
        <td><code>rb_build('{1,2,3,4,5}')</code></td>
    </tr>
    <tr>
        <td><code>rb_to_array</code></td>
        <td><code>roaringbitmap</code></td>
        <td><code>integer[]</code></td>
        <td>
            Bitmap to integer array.<BR>Bitmap转数组。
        </td>
        <td><code>rb_to_array(rb_build('{1,2,3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_and</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>roaringbitmap</code></td>
        <td>Two roaringbitmap and calculation.<BR>And计算。</td>
        <td><code>rb_and(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_or</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>roaringbitmap</code></td>
        <td>Two roaringbitmap or calculation.<BR>Or计算。</td>
        <td><code>rb_or(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_xor</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>roaringbitmap</code></td>
        <td>Two roaringbitmap xor calculation.<BR>Xor计算。</td>
        <td><code>rb_xor(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_andnot</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>roaringbitmap</code></td>
        <td>Two roaringbitmap andnot calculation.<BR>AndNot计算</td>
        <td><code>rb_andnot(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_cardinality</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td>Retrun roaringbitmap cardinality.<BR>统计基数</td>
        <td><code>rb_cardinality(rb_build('{1,2,3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_and_cardinality</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>integer</code></td>
        <td>Two roaringbitmap and calculation, return cardinality.<BR>And计算并返回基数。</td>
        <td><code>rb_and_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_or_cardinality</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>integer</code></td>
        <td>Two roaringbitmap or calculation, return cardinality.<BR>Or计算并返回基数。</td>
        <td><code>rb_or_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_xor_cardinality</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>integer</code></td>
        <td>Two roaringbitmap xor calculation, return cardinality.<BR>Xor计算并返回基数。</td>
        <td><code>rb_xor_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_andnot_cardinality</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>integer</code></td>
        <td>Two roaringbitmap andnot calculation, return cardinality.<BR>AndNot计算并返回基数。</td>
        <td><code>rb_andnot_cardinality(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_is_empty</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check if roaringbitmap is empty.<BR>判断是否为空的Bitmap。</td>
        <td><code>rb_is_empty(rb_build('{1,2,3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_equals</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check two roaringbitmap are equal.<BR>判断两个Bitmap是否相等。</td>
        <td><code>rb_equals(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
        <tr>
        <td><code>rb_not_equals</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check two roaringbitmap are not equal.<BR>判断两个Bitmap是否不同。</td>
        <td><code>rb_not_equals(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_intersect</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check two roaringbitmap are intersect.<BR>判断两个Bitmap是否相交。</td>
        <td><code>rb_intersect(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_contains</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap conatins another one.<BR>判断Bitmap是否包含另外一个。</td>
        <td><code>rb_contains(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_contains</code></td>
        <td><code>roraingbitmap<BR>integer</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap conatins a specific offset.<BR>判断Bitmap是否包含特定的Offset。</td>
        <td><code>rb_contains(rb_build('{1,2,3}'),1)</code></td>
    </tr>
    <tr>
        <td><code>rb_contains</code></td>
        <td><code>roraingbitmap<BR>integer<BR>integer</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap conatins a specific offsets range.<BR>判断Bitmap是否包含特定的Offset段。</td>
        <td><code>rb_contains(rb_build('{1,2,3}'),1,3)</code></td>
    </tr>
    <tr>
        <td><code>rb_becontained</code></td>
        <td><code>roraingbitmap<BR>roaringbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap is contained by another one.<BR>判断Bitmap是否被另外一个包含。</td>
        <td><code>rb_becontained(rb_build('{1,2,3}'),rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_becontained</code></td>
        <td><code>integer<BR>roaringbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check a specific offset is contained by Bitmap.<BR>判断特定的Offset是否被Bitmap包含。</td>
        <td><code>rb_becontained(1,rb_build('{3,4,5}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_add</code></td>
        <td><code>roraingbitmap<BR>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Add a specific offset to roaringbitmap.<BR>添加特定的Offset到Bitmap。</td>
        <td><code>rb_add(rb_build('{1,2,3}'),3)</code></td>
    </tr>
    <tr>
        <td><code>rb_add</code></td>
        <td><code>roraingbitmap<BR>integer<BR>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Add a specific offsets range to roaringbitmap.<BR>添加特定的Offset段到Bitmap。</td>
        <td><code>rb_add(rb_build('{1,2,3}'),3,4)</code></td>
    </tr>
    <tr>
        <td><code>rb_remove</code></td>
        <td><code>roraingbitmap<BR>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Remove a specific offset from roaringbitmap.<BR>从Bitmap移除特定的Offset。</td>
        <td><code>rb_remove(rb_build('{1,2,3}'),3)</code></td>
    </tr>
    <tr>
        <td><code>rb_remove</code></td>
        <td><code>roraingbitmap<BR>integer<BR>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Remove a specific offsets rang from roaringbitmap.<BR>从Bitmap移除特定的Offset段。</td>
        <td><code>rb_remove(rb_build('{1,2,3}'),2,3)</code></td>
    </tr>
     <tr>
        <td><code>rb_flip</code></td>
        <td><code>roraingbitmap<BR>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Flip a specific offset from roaringbitmap.<BR>翻转Bitmap中特定的Offset。</td>
        <td><code>rb_flip(rb_build('{1,2,3}'),3)</code></td>
    </tr>
    <tr>
        <td><code>rb_flip</code></td>
        <td><code>roraingbitmap<BR>integer<BR>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Flip a specific offsets range from roaringbitmap.<BR>翻转Bitmap中特定的Offset段。</td>
        <td><code>rb_flip(rb_build('{1,2,3}'),2,3)</code></td>
    </tr>
    <tr>
        <td><code>rb_minimum</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td>Return the smallest offset in roaringbitmap. Return -1 if the bitmap is empty.<BR>返回Bitmap中最小的Offset，如果Bitmap为空则返回-1。
        <td><code>rb_minimum(rb_build('{1,2,3}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_maximum</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td>Return the greatest offset in roaringbitmap. Return 0 if the bitmap is empty.<BR>返回Bitmap中最大的Offset，如果Bitmap为空则返回0。</td>
        <td><code>rb_maximum(rb_build('{1,2,3}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_rank</code></td>
        <td><code>roraingbitmap<BR>integer</code></td>
        <td><code>integer</code></td>
        <td>Return the number of offsets that are smaller or equal to a specific offset.<BR>返回Bitmap中小于等于指定Offset的基数。</td>
        <td><code>rb_rank(rb_build('{1,2,3}'),3)</code></td>
    </tr>
    <tr>
        <td><code>rb_jaccard_index</code></td>
        <td><code>roraingbitmap<BR>roraingbitmap</code></td>
        <td><code>float8</code></td>
        <td>Computes the Jaccard index between two bitmaps. <BR>计算两个Bitmap之间的jaccard相似系数。</td>
        <td><code>rb_jaccard_index(rb_build('{1,2,3}'),rb_build('{1,2,3，4}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_iterate</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>setof integer</code></td>
        <td>Return offsets List.<BR>返回Offset List。</td>
        <td><code>rb_iterate(rb_build('{1,2,3}'))</code></td>
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
        <td><code>&</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Two roaringbitmap and calculation.<BR>两个Bitmap And 操作。</td>
        <td><code>rb_build('{1,2,3}') & rb_build('{1,2,3}')</code></td>
    </tr>
    <tr>
        <td><code>|</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Two roaringbitmap or calculation.<BR>两个Bitmap Or 操作。</td>
        <td><code>rb_build('{1,2,3}') | rb_build('{1,2,3}')</code></td>
    </tr>
    <tr>
        <td><code>#</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Two roaringbitmap xor calculation.<BR>两个Bitmap Xor 操作。</td>
        <td><code>rb_build('{1,2,3}') # rb_build('{1,2,3}')</code></td>
    </tr>
    <tr>
        <td><code>~</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Two roaringbitmap andnot calculation.<BR>两个Bitmap Andnot 操作。</td>
        <td><code>rb_build('{1,2,3}') ~ rb_build('{1,2,3}')</code></td>
    </tr>
    <tr>
        <td><code>+</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>intger</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Add a specific offset from roaringbitmap.<BR>向Bitmap中添加特定的Offset。</td>
        <td><code>rb_build('{1,2,3}') + 4</code></td>
    </tr>
    <tr>
        <td><code>+</code></td>
        <td><code>intger</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Add a specific offset from roaringbitmap.<BR>向Bitmap添加特定的Offset。</td>
        <td><code>4 + rb_build('{1,2,3}') </code></td>
    </tr>
    <tr>
        <td><code>-</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>intger</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Remove a specific offset from roaringbitmap.<BR>从Bitmap移除特定的Offset。</td>
        <td><code>rb_build('{1,2,3}') - 1</code></td>
    </tr>
    <tr>
        <td><code>=</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check two roaringbitmap are equal.<BR>判断两个Bitmap是否相等。</td>
        <td><code>rb_build('{1,2,3}') = rb_build('{3,2,1}') </code></td>
    </tr>
    <tr>
        <td><code>&&</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check two roaringbitmaps are intersected.<BR>判断两个Bitmap是否相交。</td>
        <td><code>rb_build('{1,2,3}') && rb_build('{3,2,1}') </code></td>
    </tr>
    <tr>
        <td><code>@></code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap conatins another one.<BR>判断Bitmap是否包含另外一个</td>
        <td><code>rb_build('{1,2,3}') @> rb_build('{3,1}') </code></td>
    </tr>
    <tr>
        <td><code>@></code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap conatins a specific offset.<BR>判断Bitmap是否包含特定的Offset。</td>
        <td><code>rb_build('{1,2,3}') @> 1 </code></td>
    </tr>
    <tr>
        <td><code><@</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check roaringbitmap is contained by another one.<BR>判断Bitmap是否被另外一个包含。</td>
        <td><code>rb_build('{1,3}') <@ rb_build('{3,2,1}') </code></td>
    </tr>
    <tr>
        <td><code><@</code></td>
        <td><code>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>boolean</code></td>
        <td>Check a specific offset is contained by Bitmap.<BR>判断特定的Offset是否被Bitmap包含。</td>
        <td><code>1 <@ rb_build('{1,2,3}')  </code></td>
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
        <td><code>rb_build_agg</code></td>
        <td><code>integer</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Build a roaringbitmap from a integer set.<BR>将Offset聚合成bitmap。</td>
        <td><code>rb_build_agg(1)</code></td>
    </tr> 
    <tr>
        <td><code>rb_or_agg</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Or Aggregate calculations from a roraingbitmap set.<BR>Or 聚合计算。</td>
        <td><code>rb_or_agg(rb_build('{1,2,3}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_and_agg</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>And Aggregate calculations from a roraingbitmap set.<BR>And 聚合计算。</td>
        <td><code>rb_and_agg(rb_build('{1,2,3}'))</code></td>
    </tr>
    <tr>
        <td><code>rb_xor_agg</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>roraingbitmap</code></td>
        <td>Xor Aggregate calculations from a roraingbitmap set.<BR>Xor 聚合计算。</td>
        <td><code>rb_xor_agg(rb_build('{1,2,3}'))</code></td>
    </tr>    
    <tr>
        <td><code>rb_or_cardinality_agg</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td>Or Aggregate calculations from a roraingbitmap set, return cardinality.<BR>Or 聚合计算并返回其基数。</td>
        <td><code>rb_or_cardinality_agg(rb_build('{1,2,3}'))</code></td>
    </tr>   
    <tr>
        <td><code>rb_and_cardinality_agg</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td>And Aggregate calculations from a roraingbitmap set, return cardinality.<BR>And 聚合计算并返回其基数。</td>
        <td><code>rb_and_cardinality_agg(rb_build('{1,2,3}'))</code></td>
    </tr>  
    <tr>
        <td><code>rb_xor_cardinality_agg</code></td>
        <td><code>roraingbitmap</code></td>
        <td><code>integer</code></td>
        <td>Xor Aggregate calculations from a roraingbitmap set, return cardinality.<BR>Xor 聚合计算并返回其基数。</td>
        <td><code>rb_xor_cardinality_agg(rb_build('{1,2,3}'))</code></td>
    </tr>
</table>