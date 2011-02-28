class Hashify
  def self.convert node
    children = {}
    child_nodes = node.children

    if child_nodes.first.nil?
      children = nil
    elsif child_nodes.first.text?
      children = child_nodes.first.text
    else
      child_nodes.each do |child|
        convert(child).each_pair do |k, v|
          children[k] = if children.key? k
            children[k].is_a?(Array) ? (children[k] << v) : ([children[k], v])
          else
            v
          end
        end
      end
    end

    { node.name => children }
  end
end
