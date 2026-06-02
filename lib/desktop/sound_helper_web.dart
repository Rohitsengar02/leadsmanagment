import 'dart:js' as js;
import 'package:flutter/services.dart';

void playTukTuk() {
  try {
    js.context.callMethod('eval', ["""
      (function() {
        try {
          var AudioContext = window.AudioContext || window.webkitAudioContext;
          if (!AudioContext) return;
          var ctx = new AudioContext();
          var osc = ctx.createOscillator();
          var gain = ctx.createGain();
          
          // Tuk sound: clean woodblock/tap click with pitch and gain exponential decay
          osc.type = 'sine';
          osc.frequency.setValueAtTime(140, ctx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(15, ctx.currentTime + 0.06);
          
          gain.gain.setValueAtTime(0.18, ctx.currentTime);
          gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.06);
          
          osc.connect(gain);
          gain.connect(ctx.destination);
          
          osc.start();
          osc.stop(ctx.currentTime + 0.06);
        } catch (e) {
          console.error(e);
        }
      })()
    """]);
  } catch (e) {
    SystemSound.play(SystemSoundType.click);
  }
}
