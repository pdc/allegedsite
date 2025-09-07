from alleged.decorators import render_with


@render_with("front_page.html")
def front_page(request, blog_dir, blog_url, image_url, is_svg_wanted):
    return {
        "is_svg_wanted": is_svg_wanted,
    }
