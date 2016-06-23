module CoreExtensions
  module String
    def constantize
      Object.const_get(self)
    end
  end
end
