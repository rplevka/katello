#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Katello
  module SubscriptionsHelper

    def subscriptions_product_helper(product_id)
      cp_product = Resources::Candlepin::Product.get(product_id).first
      product = OpenStruct.new cp_product
      product.cp_id = cp_product['id']
      product
    end

    def subscriptions_manifest_link_helper(status, label = nil)
      if status['webAppPrefix']
        if !status['webAppPrefix'].start_with? 'http'
          url = "http://#{status['webAppPrefix']}"
        else
          url = status['webAppPrefix']
        end

        url += '/' unless url.end_with? '/'
        url += status['upstreamId']
        link_to((label.nil? ? url : label), url, :target => '_blank')
      else
        label.nil? ? status['upstreamId'] : label
      end
    end

    def subscriptions_candlepin_status
      Resources::Candlepin::CandlepinPing.ping
    rescue
      {'rulesVersion' => '', 'rulesSource' => ''}
    end
  end
end
