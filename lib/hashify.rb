class Hashify
  def self.convert node
    return node.text if node.text?

    { node.name => node.children.map { |x| convert x } }
  end
end
