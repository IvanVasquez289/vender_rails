require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render a list of producst' do
    get products_path

    assert_response :success
    assert_select '.product', 2
  end

  test 'render a show page' do
    get product_path(products(:ps5))

    assert_response :success
    assert_select '.title', 'PS5 Slim'
    assert_select '.description', 'Se encuentra en buen estado'
    assert_select '.price', '150$'
  end


  test 'render a new product form' do
    get new_product_path

    # esperamos que al visitar ese get la respuesta sea satisfactoria y que haya un elemento html de tipo form
    assert_response :success
    assert_select 'form'
  end

  test 'allow to create a new product' do
    post products_path, params: {
      product: {
        title: 'Cartera',
        description: 'Material de piel',
        price: 289
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha creado correctamente' #comprobar que el contenido de flash en notice debe ser igual a lo que esta en ''
  end

  test 'does not allow to create a new product with empty fields' do
    post products_path, params: {
      product: {
        title: '',
        description: 'Material de piel',
        price: 289
      }
    }

    assert_response :unprocessable_entity
  end

  test 'render an edit product form' do
    get edit_product_path(products(:ps5))

    # esperamos que al visitar ese get la respuesta sea satisfactoria y que haya un elemento html de tipo form
    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:ps5)), params: {
      product: {
        price: 200
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente' #comprobar que el contenido de flash en notice debe ser igual a lo que esta en ''
  end

  test 'does not allow to update a product with empty fields' do
    patch product_path(products(:ps5)), params: {
      product: {
        price: 200,
        description: ''
      }
    }
    assert_response :unprocessable_entity
  end

  test 'can delete products' do 
    assert_difference "Product.count", -1 do
      delete product_path(products(:ps5))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
  end

  
end