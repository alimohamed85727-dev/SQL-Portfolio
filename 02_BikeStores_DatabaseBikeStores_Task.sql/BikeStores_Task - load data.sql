                              ----بسم الله الرحمن الرحيم----
--- Q1 يريد مدير المبيعات تحديد العملاء الأكثر قيمة للشركة بناءً على عدد الطلبات التي قدموها.
---سيتم استخدام هذا التقرير لدعم برنامج ولاء العملاء من خلال التعرف على العملاء الذين يقومون بالشراء بشكل متكرر.
---قم بإعداد تقرير يساعد مدير المبيعات في التعرف على العملاء ذوي النشاط الشرائي الأعلى.

SELECT Top 10 
        c.customer_id,
        c.first_name+''+c.last_name as Customer_Name,
        c.email,
        count(o.order_id) as Total_Orders

FROM 
        sales.customers c 
 inner join 
        sales.orders o

On      
        c.customer_id = o.customer_id
Group by 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email
ORDER by
        Total_Orders desc ;
-------------------------------------------------------
--Q2يرغب مدير المخزون في تحديد المنتجات المعرضة لخطر نفاد الكميات في متاجر الشركة.
--سيُستخدم التقرير لدعم تخطيط المخزون وضمان استمرار توفر المنتجات الرائجة للعملاء.
--أعِدَّ تقريراً يساعد مدير المخزون على تحديد المنتجات ذات أقل مستويات مخزون متاحة.

SELECT Top 20
   P.product_id,
   P.product_name,
   ISNULL(SUM(S.quantity),0) As Total_Stock_Quantity
FROM
   production.products P 
left join
   production.stocks S
on P.product_id = S.product_id 
Group BY 
   P.product_id,
   P.product_name
Order By 
   Total_Stock_Quantity Asc; 
--------------------------------------------------------------
---Q3يريد مدير المنتج معرفة فئات المنتجات التي تحتوي على أكبر عدد من المنتجات.
---سيساعد هذا التقرير في تقييم مجموعة منتجات الشركة ودعم تخطيط المنتجات المستقبلية.
---قم بإعداد تقرير يلخص عدد المنتجات المتوفرة في كل فئة.
SELECT 
     C.category_name,
     count(P.product_id) AS Total_Product
FROM 
     production.categories C
Inner Join
     production.products P
ON C.category_id = P.category_id
Group By 
     C.category_name
Order By 
     Total_Product Desc;
------------------------------------------------------------
---Q4يرغب مدير المبيعات في مقارنة أداء مبيعات المنتجات عبر سنوات مختلفة.
---قم بإعداد تقرير يوضح إجمالي الكميات المباعة من كل منتج في كل عام، وذلك لتحديد اتجاهات المبيعات ودعم تخطيط الأعمال المستقبلي.
SELECT  
     Year(O.order_date) AS order_Year,
     P.product_name,
     Sum(I.quantity) AS Total_Quantity
FROM 
     sales.orders O
Inner Join 
     sales.order_items I
ON O.order_id = I.order_id
Inner Join
     production.products P
ON I.product_id = P.product_id
Group By 
     Year(O.order_date),
     P.product_name
     
Order By 
     order_Year ASC,
     Total_Quantity DESC;
---------------------------------------------------------------
---Q5يريد مدير المنتج تحديد المنتجات التي لم يتم بيعها مطلقًا.
---قد تتطلب هذه المنتجات حملات ترويجية، أو تعديلات الأسعار، أو مراجعة المخزون.
---إعداد تقرير يوضح جميع المنتجات التي لم تظهر من قبل في أي طلب عميل.
SELECT 
     P.product_name
FROM 
     production.products P
Left Join 
     sales.order_items I
ON P.product_id = I.product_id
Where I.product_id IS NULL  
------------------------------------------------------------------
---Q6يريد مدير المبيعات تحديد عملاء الشركة الأكثر قيمة بناءً على المبلغ الإجمالي الذي أنفقوه.
---سيتم استخدام هذا التقرير للتعرف على العملاء المخلصين ودعم الحملات التسويقية وتطوير استراتيجيات الاحتفاظ بالعملاء.
---قم بإعداد تقرير يوضح العملاء الذين حققوا أعلى إجمالي مبيعات.
 CREATE Function sales.Total_Amount_Sales(
        @quantity INT
        ,@list_price DEC (10,2)
        ,@discount DEC (4,2)
        )
   RETURNS DEC (10,2)
    AS 
    Begin
         RETURN (@quantity * @list_price * (1-@discount))
    END;
GO
    -----------------------
SELECT 
     C.first_name+' '+C.last_name AS Customer_Name,
     SUM(sales.Total_Amount_Sales
               (OI.quantity,OI.list_price,OI.discount)) AS Total_Amount
  FROM
       sales.customers C
     Inner Join 
       sales.orders O
      ON  C.customer_id = O.customer_id
     Inner Join
       sales.order_items OI
      ON  O.order_id = OI.order_id
  Group By
         C.customer_id,
         C.first_name,
         C.last_name
  Order By  
         Total_Amount DESC;
-------------------------------------------------------
---Q7يرغب مدير المنتج في تقييم أداء المبيعات لكل فئة من فئات المنتجات.
---يُرجى إعداد تقرير يوضح إجمالي قيمة المبيعات المحققة لكل فئة، وذلك لتحديد الفئات ذات الأداء الأفضل والفئات ذات الأداء الأقل
SELECT 
     category_name,
     SUM(sales.Total_Amount_Sales
               (OI.quantity,OI.list_price,OI.discount)) AS Total_Amount
               FROM 
                 production.categories C
               Inner Join
                 production.products P ON C.category_id = P.category_id
               Inner Join 
                 sales.order_items OI ON P.product_id = OI.product_id

          Group By
             C.category_name
          Order By
             Total_Amount;
-----------------------------------------------------------------------------------------
---Q8يريد مدير العمليات مقارنة حجم العمل في جميع المتاجر.
---إعداد تقرير يوضح إجمالي عدد الطلبات التي تمت معالجتها بواسطة كل متجر.
---سيساعد هذا التقرير في تقييم نشاط المتجر ودعم التخطيط التشغيلي.
SELECT 
     store_name,
     COUNT(order_id) AS Total_Orders
     FROM
         sales.stores S
     Left Join sales.orders O ON S.store_id =O.store_id
Group By
        store_name  
Order By
        Total_Orders;
-------------------------------------------------------------------
---Q9يرغب مدير الموارد البشرية في تقييم عبء العمل الخاص بكل موظف من موظفي المبيعات.
---قم بإعداد تقرير يوضح إجمالي عدد الطلبات التي تولى كل موظف إنجازها.
---سيُستخدم هذا التقرير لتقييم توزيع أعباء العمل ودعم القرارات المستقبلية المتعلقة بالموارد البشرية.
SELECT 
     (S.first_name+' '+S.last_name) AS Staff_Name,
     COUNT(order_id) AS Total_Orders
       FROM
          sales.staffs S
          Left Join sales.orders O ON S.staff_id = O.staff_id
Group By
        S.first_name+' '+S.last_name
Order By 
        Total_Orders;
--------------------------------------------------------------------------
---Q10يريد مدير الإنتاج فهم مجموعة المنتجات الخاصة بكل علامة تجارية.
---قم بإعداد تقرير يوضح العدد الإجمالي للمنتجات المتاحة لكل علامة تجارية.
---سيساعد هذا التقرير في تقييم تنوع العلامة التجارية ودعم قرارات الشراء المستقبلية.
SELECT
     B.brand_name,
     Count(P.product_id) AS Total_Products
       FROM 
           production.brands B
           Left Join production.products P
             ON B.brand_id = P.brand_id

Group By
       B.brand_name
Order By
       Total_Products DESC;
---------------------------------------------------------------------
---Q11يرغب مدير التسويق في تحديد العملاء الذين أجروا طلباً واحداً فقط ولم يعودوا للشراء مرة أخرى.
---أعدَّ تقريراً يوضح العملاء الذين أجروا طلباً واحداً بالضبط.
---سيُستخدم هذا التقرير لإطلاق حملات تهدف إلى الاحتفاظ بالعملاء.
SELECT 
     C.customer_id,
     C.first_name +' '+ C.last_name AS Customer_Name,
     Count(O.order_id) AS Num_Of_Order
       FROM 
          sales.customers C
          Inner Join sales.orders O ON C.customer_id = O.customer_id
Group By 
       C.customer_id,
       C.first_name +' '+ C.last_name 

Having
       Count(O.order_id) = 1 ;
------------------------------------------------------------------
---Q12يرغب مدير التسويق في تحديد العملاء العائدين الذين أجروا أكثر من عملية شراء واحدة.
---قم بإعداد تقرير يوضح العملاء الذين قدموا طلبات متعددة.
---سيساعد هذا التقرير في تقييم ولاء العملاء ودعم مبادرات برامج الولاء.
SELECT 
     C.customer_id,
     C.first_name +' '+ C.last_name AS Customer_Name,
     Count(O.order_id) AS Num_Of_Order
       FROM 
          sales.customers C
          Inner Join sales.orders O ON C.customer_id = O.customer_id
Group By 
       C.customer_id,
       C.first_name +' '+ C.last_name
Having 
       Count(O.order_id) > 1 ;

------------------------------------------------------------------------
--===========================اللهم لك الحمد===========================--
------------------------------------------------------------------------



