$(document).on("ready page:load",function(){

    // ## Delete product
    $('body').delegate('.remove_link a', 'click', function(){
      var product_id = $(this).attr('id').slice(3);
      var product_count;
      var total_price = 0;
      $(this).parents('tr').find( ".total" ).removeClass();
      $(this).parents('tr').hide(500);
      if ($('#current_user').text()) {
        var cookie_value = document.cookie.replace(/(?:(?:^|.*;\s*)user_products_count\s*\=\s*([^;]*).*$)|^.*$/, "$1");
        var product_count = $(this).parents('tr').find( ".quantity-input" ).val();
        var pathname = 'http://' + $(location).attr('host') + '/order_items/' + product_id;
        var data = { product_count: product_count }
        var obj = cookie_value ? jQuery.parseJSON(decodeURIComponent(cookie_value)) : {count: "0"};

        // Change count products in shop carts
        $('.cart-lnk em').text("(" + (parseInt($('.cart-lnk em').text().slice(1, -1)) - product_count) + ")");
        if ($('.cart-lnk em').text() == '(0)' ) {$('.cart-lnk em').text('(empty)')}
        obj['count'] = (parseInt(obj['count']) - product_count).toString() ;
        if (obj['count'] <= 0) {obj['count'] = '0'}
        setCookie('user_products_count', JSON.stringify(obj));
        if (obj['count'] == '0') { 
            $('.full_cart').hide(300).delay(2000)
            $('.cart_empty').show(300).delay(3000).fadeIn( 500 );
        }
        ajaxRequest(pathname, data, 'DELETE');
      } else {

        var cookie_value = document.cookie.replace(/(?:(?:^|.*;\s*)books\s*\=\s*([^;]*).*$)|^.*$/, "$1");
        var product_count = document.cookie.replace(/(?:(?:^|.*;\s*)book_count\s*\=\s*([^;]*).*$)|^.*$/, "$1");

        if (cookie_value) {
          var obj = jQuery.parseJSON(decodeURIComponent(cookie_value));
          product_count = jQuery.parseJSON(decodeURIComponent(product_count));

          // Change count products in shop carts
          $('.cart-lnk em').text("(" + (parseInt($('.cart-lnk em').text().slice(1, -1)) - parseInt(obj[product_id])) + ")");
          if ($('.cart-lnk em').text() == '(0)' ) {$('.cart-lnk em').text('(empty)')}


          // Delete cookies
          product_count['book_count'] =  product_count['book_count'] - parseInt(obj[product_id]);
          delete obj[product_id];
          if (product_count['book_count'] == '0') { 
            deleteCookie('book_count') 
            deleteCookie('books') 
            $('.full_cart').hide(300).delay(2000)
            $('.cart_empty').show(300).delay(3000).fadeIn( 500 );
          } else {
            setCookie('book_count', JSON.stringify(product_count));
            setCookie('books', JSON.stringify(obj));
          }
        }

      }

      //Change total price
      $( ".total" ).map(function(index, element) {
        total_price += parseFloat($(this).text().substring(1, $(this).text().length));
      });
      $('.order-summary-line span').text(number_to_currency(total_price));

    });

    // ## Update shop cart
    $('body').delegate('#update', 'click', function(){
      var pathname = 'http://' + $(location).attr('host') + '/orders/update_shopcart_ajax';
      var price, data, qty, total, quantity = total_price = 0;
      var data = {};
      //Change total price
      $( ".tr" ).map(function(index, element) {

        price = $(this).find('.book_price').text().substring(1, $(this).text().length);
        id = $(this).find('.remove_link a').attr('id').slice(3);
        qty = $(this).find('.count input').val();
        total = price * qty;
        total_price = total_price + total;
        quantity = quantity + parseInt(qty)
        data[id] = qty;
        $(this).find('.total').text(number_to_currency(total));
        

      });
      if ($('#current_user').text()) {
        ajaxRequest(pathname, data, 'PUT');
        $('.cart-lnk  em'). text("("+ quantity +")");
        setCookie('user_products_count', JSON.stringify({count: quantity}));
      } else {
        $('.cart-lnk  em'). text("("+ quantity +")");
        updateCookie(data, quantity);
      }
      $('.order-summary-line span').text(number_to_currency(total_price));

    });
    
    // ## Check cupon
    $('body').delegate('#checkout', 'click', function (event){
      cupon = $('.cupon').val();
      language = $(this).attr('href').slice(1,3);
      if(cupon.length == 0 ) {return true;}

      if(cupon.length != 9 && cupon.length != 0) {
        alert('code consists of 9 digits!');
        return false;
      }
      
      if (cupon.length != 0) {
        event.preventDefault();
        var value = $('.cupon').val()
        var pathname = 'http://' + $(location).attr('host') + '/orders/check_cupon_ajax';

        $.ajax({
          type: "POST",
          url: pathname,
          data: "value=" + value,

          success: function(msg){
            
            result = confirm(msg) ? true : false;
            if(result) {
              var address = 'http://' + $(location).attr('host') +'/' + language + '/order_steps/address?' + "value=" + value;
              window.location.replace(address);
            }
          },
          error:function(msg){
            alert("Error");
          } 
        });

      }

    });

});