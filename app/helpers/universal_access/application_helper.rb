module UniversalAccess
  module ApplicationHelper
    
    def ficon(i)
      return "<i class='fa fa-#{i}'></i>".html_safe
    end
    
  end
end
