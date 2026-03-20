# -*- coding: utf-8 -*-
import zipfile
import os
import sys

def extract_docx(file_path, output_path):
    try:
        with zipfile.ZipFile(file_path, 'r') as zip_ref:
            # Extract the document.xml
            if 'word/document.xml' in zip_ref.namelist():
                content = zip_ref.read('word/document.xml')
                
                # Try to decode as utf-8
                try:
                    text = content.decode('utf-8')
                except:
                    try:
                        text = content.decode('gbk')
                    except:
                        text = content.decode('utf-8', errors='ignore')
                
                # Extract text between <w:t> tags
                import re
                text_nodes = re.findall(r'<w:t[^>]*>(.*?)</w:t>', text, re.DOTALL)
                
                full_text = '\n'.join(text_nodes)
                
                with open(output_path, 'w', encoding='utf-8') as f:
                    f.write(full_text)
                return True
    except Exception as e:
        print(f"Error: {e}")
        return False
    return False

src_dir = r"D:\相关资料\openclaw"
dst_dir = r"C:\Users\Administrator\.openclaw\workspace\extracted_docs"

os.makedirs(dst_dir, exist_ok=True)

for f in os.listdir(src_dir):
    if f.endswith('.docx'):
        src_path = os.path.join(src_dir, f)
        dst_path = os.path.join(dst_dir, f.replace('.docx', '.txt'))
        print(f"Processing: {f}")
        if extract_docx(src_path, dst_path):
            print(f"  -> Saved: {dst_path}")
        else:
            print(f"  -> Failed")
