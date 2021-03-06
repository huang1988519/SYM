// The MIT License (MIT)
//
// Copyright (c) 2017 - 2018 zqqf16
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa

class DownloadButton: NSButton {

    var progress: NSProgressIndicator!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let frame = CGRect(x: 6, y: self.bounds.height - 7, width: self.bounds.width - 12, height: 2)
        self.progress = NSProgressIndicator(frame: frame)
        self.progress.style = .bar
        self.progress.isHidden = true

        self.addSubview(self.progress)
        
        NotificationCenter.default.addObserver(self, selector: #selector(downloadStatusChanged(_:)), name: .dsymDownloadStatusChanged, object: nil)
    }
    
    func startAnimation() {
        self.progress.startAnimation(nil)
        self.progress.isHidden = false
    }
    
    func stopAnimation() {
        self.progress.stopAnimation(nil)
        self.progress.isHidden = true
    }
    
    @objc func downloadStatusChanged(_ notification: Notification?) {
        DispatchQueue.main.async {
            let active = DsymDownloader.shared.tasks.values.filter {
                $0.isRunning
            }
            
            if active.count > 0 {
                self.startAnimation()
            } else {
                self.stopAnimation()
            }
        }
    }
}
