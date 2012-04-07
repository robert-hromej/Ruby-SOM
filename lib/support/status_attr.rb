class Class

  def status_attr *attrs
    attrs.each do |attr|

      define_method("#{attr}?") do
        !!instance_variable_get("@#{attr}")
      end

      define_method("#{attr}!") do
        instance_variable_set("@#{attr}", true)
      end

      define_method("not_#{attr}!") do
        instance_variable_set("@#{attr}", false)
      end

    end
  end
end
