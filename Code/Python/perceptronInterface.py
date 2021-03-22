# Interface Programm for the Validation of the Perceptron Project
# Subject: Digitaldesign at the Ernst-Abbe-Hochschule Jena
# Author: Fabian Franz
import tkinter as tk

# Set the main window
window = tk.Tk()
window.geometry("540x600")
window.title("PerceptronPixel Interface")

t = Text(root, height=2, width=30)
t.pack
t.insert()


for x in range(n):
    for y in range(n):
        b = tk.Button(window, highlightbackground="black", height=2, width=2)
        b.grid(column=x, row=y)
        b["command"] = lambda b=b: setPixel(b)
b = tk.Button(highlightbackground="black", height=2, width=2)
b.place(x=300, y=500)


def setPixel(button):
    """Set a single Pixel active."""
    if button["text"] == "":
        button["text"] = "set"
    else:
        button["text"] = ""


w = arrange()
tk.mainloop()
