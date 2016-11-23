class String
  def classify
    self.split('_').collect(&:capitalize).join
  end
end
