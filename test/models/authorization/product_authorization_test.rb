require 'models/authorization/authorization_base'

module Katello
  class ProductAuthorizationAdminTest < AuthorizationTestBase
    def setup
      super
      User.current = User.find(users('admin').id)
      @prod = @fedora
      @org = @acme_corporation
    end

    def test_readable
      refute_empty Product.readable
    end

    def test_editable
      refute_empty Product.editable
    end

    def test_syncable
      refute_empty Product.syncable
    end

    def test_deletable
      refute_empty Product.deletable
    end

    def test_readable?
      assert @prod.readable?
    end

    def test_syncable?
      assert @prod.syncable?
    end

    def test_editable?
      assert @prod.editable?
    end

    def test_deletable?
      product = Product.find(katello_products(:empty_product).id)
      assert product.deletable?
    end

    def test_readable_repositories
      refute_empty Product.readable_repositories
    end

    def test_readable_repositories_with_ids
      refute_empty Product.readable_repositories([Repository.first.id])
    end
  end

  class ProductAuthorizationNoPermsTest < AuthorizationTestBase
    def setup
      super
      User.current = User.find(users('restricted').id)
      @prod = @fedora
      @org = @acme_corporation
    end

    def test_readable
      assert_empty Product.readable
    end

    def test_editable
      assert_empty Product.editable
    end

    def test_syncable
      assert_empty Product.syncable
    end

    def test_deletable
      assert_empty Product.deletable
    end

    def test_readable?
      refute @prod.readable?
    end

    def test_syncable?
      refute @prod.syncable?
    end

    def test_editable?
      refute @prod.editable?
    end

    def test_deletable?
      refute @prod.deletable?
    end

    def test_readable_repositories
      assert_empty Product.readable_repositories
    end

    def test_readable_repositories_with_ids
      assert_empty Product.readable_repositories([Repository.first.id])
    end

    def test_readable_repositories_with_search
      setup_current_user_with_permissions(:name => "view_products",
                                          :search => "name=\"#{Repository.first.product.name}\"")

      assert_equal([Repository.first], Product.readable_repositories([Repository.first.id]))
      assert_empty(Product.readable_repositories([Repository.where('product_id != ?', Katello::Product.readable.pluck(:id)).first]))
    end
  end
end
