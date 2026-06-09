<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <script>
    let startPicker, endPicker;
    document.addEventListener("DOMContentLoaded", function() {
      startPicker = flatpickr("#_qemitdate", {
        dateFormat: "Y/m/d",
        onChange: function(selectedDates) {
          if (selectedDates.length > 0) {
            endPicker.set("minDate", selectedDates[0]);
          }
        }
      });

      endPicker = flatpickr("#_qrestdate", {
        dateFormat: "Y/m/d",
        onChange: function(selectedDates) {
          if (selectedDates.length > 0) {
            startPicker.set("maxDate", selectedDates[0]);
          }
        }
      });
    });
  </script>
