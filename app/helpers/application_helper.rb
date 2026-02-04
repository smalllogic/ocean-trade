module ApplicationHelper
  def flash_color(type)
    {
      notice: "bg-blue-50 border-l-4 border-blue-500 text-blue-700",
      success: "bg-green-50 border-l-4 border-green-500 text-green-700",
      alert: "bg-yellow-50 border-l-4 border-yellow-500 text-yellow-700",
      error: "bg-red-50 border-l-4 border-red-500 text-red-700"
    }[type.to_sym] || "bg-gray-50 border-l-4 border-gray-500 text-gray-700"
  end
end
