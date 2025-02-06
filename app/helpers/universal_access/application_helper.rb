# frozen_string_literal: true

module UniversalAccess
  module ApplicationHelper
    def ficon(i)
      "<i class='fa fa-#{i}'></i>".html_safe
    end
  end
end
